class Player

    attr_reader :name 
    attr_accessor :losses

    def initialize(name)
        @name = name
        @losses = 1
    end

end