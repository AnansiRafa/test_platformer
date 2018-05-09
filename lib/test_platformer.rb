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
      @jumpsound = Gosu::Sample.new("./assets/sounds/jump_sound.mp3")
      @pose = @stand
    end

    def floor?
      self.y === 400
    end

    def warp(x,y)
      @x, @y = x, y
    end

    def move
    end

    def draw
      # @image.draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
      if @pose == @stand || @pose == @jump
      if @dir == :right
        offs_x = -50
        x_factor = 0.2
      else
        offs_x = 50
        x_factor = -0.2
      end
      @pose.draw(@x + offs_x, @y - 49, 0, x_factor, 0.2)
    else
      if @dir == :right
        offs_x = -50
        x_factor = 0.35
      else
        offs_x = 50
        x_factor = -0.35
      end
      @pose.draw(@x + offs_x, @y - 49, 0, x_factor, 0.40)
    end
    end

    def update(move_x)
      #choose sprite image based on movement
      if (self.floor?) && (move_x == 0)
        @pose = @stand
      elsif (@vy < 0)
        @pose = @jump
      elsif (self.floor?) && ((move_x > 0) || (move_x < 0))
        @pose = @run
      else
        @pose = @jump
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
        @vy.times { if !(self.floor?) then @y += 1 else @vy = 0 end }
      end
      if @vy < 0
        (-@vy).times {  @y -= 1 }
      end

    end
    def jump
      if @vy == 0
        @vy = -20
        @jumpsound.play
      end
    end
  end


  class Window < Gosu::Window
    def initialize
      super 700, 480
      self.caption = "Testing..."
      @player = Player.new
      @player.warp(70, 200)
    end

    def update
      move_x = 0
      move_x -= 5 if Gosu.button_down? Gosu::KB_LEFT
      move_x += 5 if Gosu.button_down? Gosu::KB_RIGHT
      @player.update(move_x)
    end

    def draw
      @player.draw
    end

    def button_down(id)
      case id
      when Gosu::KB_UP
        @player.jump
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
