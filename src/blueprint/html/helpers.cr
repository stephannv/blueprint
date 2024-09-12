module Blueprint::HTML::Helpers
  def tokens(conditions : Hash(Proc(Bool), String)) : String
    String.build do |io|
      conditions.each do |proc, classes|
        if proc.call
          io << " " unless io.empty?
          io << classes
        end
      end
    end
  end
end
