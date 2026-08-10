class Watch
  def initialize(glob, prefire: true, wait: 0.5, &block)
    raise "must pass a block" unless block_given?

    @glob = glob
    @wait = wait
    @block = block

    snapshot!
    @block.call if prefire

    run_loop
  end

  private

  def run_loop
    loop do
      if changes?
        @block.call
        snapshot!
      end

      sleep @wait
    end
  end

  def changes?
    @timestamps != timestamps
  end

  def snapshot!
    @timestamps = timestamps
  end

  def timestamps
    Dir[@glob].map do |file|
      File.mtime(file)
    rescue Errno::ENOENT
      nil
    end
  end
end
