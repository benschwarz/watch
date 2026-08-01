class Watch
  def initialize(glob, prefire: true, &block)
    raise "must pass a block" unless block_given?

    @glob = glob
    @block = block

    snapshot!
    @block.call if prefire

    run_loop
  end

  private

  def run_loop
    loop do
      @block.call if changes?
      snapshot!
      sleep 0.5
    end
  end

  def changes?
    @timestamps != timestamps
  end

  def snapshot!
    @timestamps = timestamps
  end

  def timestamps
    Dir[@glob].map { |file| File.mtime(file) }
  end
end
