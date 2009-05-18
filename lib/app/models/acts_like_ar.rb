module ActsLikeAR
	module ClassMethods; end
	def self.included(klass)
		klass.extend(ClassMethods)
	end
		
	module ClassMethods
		def create(attributes = {})
			ret = self.new
			attributes.each{|property, value|
				ret.send((property.to_s + '=').to_sym, value)
			}
			ret
		end
	end
end
