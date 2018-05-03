require 'rubygems'
require 'gosu'

module TestPlatformer
  # Your code goes here...
  class Player
    def initialize
      @image = Gosu::Image.new('./assets/images/sonic.png')
      @x = @y = @vel_x = @vel_y = 0.0
      @dir = :right
    end

    def warp(x,y)
      @x, @y = x, y
    end

    def move
    end

    def draw
      # @image.draw(@x, @y, 0, 0.3, 0.3)
      if @dir == :right
        offs_x = -25
        factor = 0.3
      else
        offs_x = 25
        factor = -0.3
      end
      @image.draw(@x + offs_x, @y - 49, 0, factor, 0.3)
    end

    def update(move_x)
      # Directional walking, horizontal movement
      if move_x > 0
        @dir = :right
        move_x.times { @x += 1 }
      end
      if move_x < 0
        @dir = :left
        (-move_x).times { @x -= 1 }
      end
    end
  end

  class Window < Gosu::Window
    def initialize
      super 640, 480
      self.caption = "Testing..."
      @sonic = Player.new
      @sonic.warp(70, 115)
    end

    def draw
      @sonic.draw
    end

    def update
      move_x = 0
      move_x -= 5 if Gosu.button_down? Gosu::KB_LEFT
      move_x += 5 if Gosu.button_down? Gosu::KB_RIGHT
      @sonic.update(move_x)
    end
  end

  window = Window.new
  window.show
end
