class Packr
  module FileSystem
    
    def self.bundle(source_paths, output_path, options)
      output = output_path && File.expand_path(output_path)
      
      sections = source_paths.map do |source|
        path = File.expand_path(source)
        relative = relative_path(path, output)
        {:code => File.read(path), :source => relative}
      end
      
      packed = Packr.pack(sections,
        :minify       => options[:minify],
        :shrink_vars  => options[:shrink_vars],
        :private      => options[:private],
        :base62       => options[:base62],
        :protect      => options[:protect],
        :header       => options[:header],
        :output_file  => output
      )
      source_map = packed.source_map
      
      if output
        FileUtils.mkdir_p(File.dirname(output))
        File.open(output, 'w') { |f| f.write(packed) }
        File.open(source_map.filename, 'w') { |f| f.write(source_map.to_s) }
      end
      
      packed
    end
    
    def self.relative_path(source, target)
      return source unless target
      
      target_parts = target.split('/')
      source_parts = source.split('/')
      
      while target_parts.first == source_parts.first
        target_parts.shift
        source_parts.shift
      end
      
      ('../' * (target_parts.size-1)) + source_parts.join('/')
    end
    
  end
end
