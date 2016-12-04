class Refactor
  module Options

    DEFAULTS = {
      path:      '.',
    }

    def self.with_defaults(options)
      _deep_merge(DEFAULTS, options)
    end

    private

    def self._deep_merge(hash1, hash2)
      hash1.merge(hash2) do |_key, oldval, newval|
        if oldval.instance_of?(Hash) && newval.instance_of?(Hash)
          _deep_merge(oldval, newval)
        else
          newval
        end
      end
    end
  end
end