require 'rubygems'
require 'gosu'

module TestPlatformer
  # Your code goes here...
  class Player
    attr_reader :x, :y, :vy

    def initialize
      @x = @y = @vy = 0
      @dir = :right
      @stand = Gosu::Image.new('./assets/images/sonic_stand.png')
      @jump = Gosu::Image.new('./assets/images/sonic_jump.gif')
      @run = Gosu::Image.new('./assets/images/sonic_run.gif')
      @pose = @stand
    end

    def floor?
      self.y === 333
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
      @pose.draw(@x + offs_x, @y - 49, 0, factor, 0.3)
    end

    def update(move_x)
      if (@vy < 0)
        @pose = @jump
      else
        @pose = @stand
      end
      # Directional walking, horizontal movement
      if move_x > 0
        @dir = :right
        move_x.times { @x += 1 }
      end
      if move_x < 0
        @dir = :left
        (-move_x).times { @x -= 1 }
      end

      #gravity
      @vy += 1

      #Vertical movement

      if @vy > 0
        @vy.times { @y += 1} until self.floor?
      end
      if @vy < 0
        (-@vy).times {  @y -= 1 }
      end

    end
    def jump
      @vy = -20
    end
  end


  class Window < Gosu::Window
    def initialize
      super 700, 480
      self.caption = "Testing..."
      @sonic = Player.new
      @sonic.warp(70, 333)
    end

    def update
      move_x = 0
      move_x -= 5 if Gosu.button_down? Gosu::KB_LEFT
      move_x += 5 if Gosu.button_down? Gosu::KB_RIGHT
      @sonic.update(move_x)
    end

    def draw
      @sonic.draw
    end

    def button_down(id)
      case id
      when Gosu::KB_UP
        @sonic.jump
      when Gosu::KB_ESCAPE
        close
      else
        super
      end
    end


  end

  window = Window.new
  window.show
end
