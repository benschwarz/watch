RSpec.describe Watch do
  around do |example|
    Dir.mktmpdir do |dir|
      @dir = dir
      FileUtils.touch(path("existing.txt"))
      example.run
    end
  end

  after { stop_watching }

  def path(name)
    File.join(@dir, name)
  end

  def start_watching(**options)
    @fires = Queue.new
    @thread = Thread.new do
      Watch.new(path("**/*"), **{wait: 0.01}.merge(options)) { @fires << :fired }
    end
    @thread.report_on_exception = false
    @thread
  end

  def stop_watching
    @thread&.kill
    @thread&.join
  end

  def wait_for_fire
    Timeout.timeout(2) { @fires.pop }
  rescue Timeout::Error
    @thread.join if @thread.status.nil?
    raise
  end

  def settle
    sleep 0.2
    @thread.join if @thread && @thread.status.nil?
  end

  it "raises without a block" do
    expect { Watch.new(path("**/*")) }.to raise_error("must pass a block")
  end

  describe "on startup" do
    it "fires the block exactly once" do
      start_watching

      expect(wait_for_fire).to eq(:fired)
      settle
      expect(@fires).to be_empty
    end

    it "does not fire the block when prefire is false" do
      start_watching(prefire: false)

      settle
      expect(@fires).to be_empty
    end
  end

  describe "while watching" do
    before do
      start_watching
      wait_for_fire
    end

    it "fires when a file is added" do
      File.write(path("added.txt"), "abc")

      expect(wait_for_fire).to eq(:fired)
    end

    it "fires when a file is modified" do
      modified = Time.now + 10
      File.utime(modified, modified, path("existing.txt"))

      expect(wait_for_fire).to eq(:fired)
    end

    it "fires when a file is removed" do
      File.delete(path("existing.txt"))

      expect(wait_for_fire).to eq(:fired)
    end

    it "does not fire when nothing changes" do
      settle

      expect(@fires).to be_empty
    end
  end

  describe "when a change lands mid-poll" do
    it "is not lost" do
      start_watching(wait: 0.5)
      wait_for_fire
      settle

      listing = Dir.method(:[])
      allow(Dir).to receive(:[]) do |glob|
        listing.call(glob).tap do
          File.write(path("added.txt"), "abc") unless File.exist?(path("added.txt"))
        end
      end

      expect(wait_for_fire).to eq(:fired)
    end
  end

  describe "wait" do
    it "polls no sooner than the given interval" do
      start_watching(wait: 5)
      wait_for_fire
      settle

      File.write(path("added.txt"), "abc")
      settle

      expect(@fires).to be_empty
    end
  end

  describe "when a file disappears mid-scan" do
    it "keeps watching" do
      allow(Dir).to receive(:[]).and_return([path("vanished.txt")])

      start_watching
      wait_for_fire
      settle

      expect(@thread).to be_alive
    end
  end
end
