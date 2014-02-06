require 'RMagick'
include Magick

def test!
	randomizer = Randomizer.new
	randomizer.randomize(:verticalGradient)
end


class Randomizer

	attr_accessor(
		:width,
		:height,
		:base
	)

	def initialize
		@width=400
		@height=400

		createBaseImage
	end

	def randomize(randFunct = :pureRandom, seed=Random.new_seed)
		random = Random.new(seed)

		@base.each_pixel{ |pixel, x, y|
			p = send(randFunct, random, x, y, @base)
			@base.pixel_color(x, y, p)
		}
		puts seed
		@base.write("randomed.png")
	end

	def pureRandom(random, x, y, base)
		p = Pixel.new(random.rand(0..QuantumRange), random.rand(0..QuantumRange), random.rand(0..QuantumRange), 1)
		return p
	end


	def linearHorizontal(random, x, y, base)
		return pureRandom(random, x, y, base) if x==0
		prevP = base.pixel_color(x-1,y)
		return Pixel.new(random.rand(prevP.red-QuantumRange/10..prevP.red+10), random.rand(prevP.green-10..prevP.green+10), random.rand(prevP.blue-10..prevP.blue+10), 1)
	end

	def linearVertical(random, x, y, base)
		return pureRandom(random, x, y, base) if y==0
		prevP = base.pixel_color(x,y-1)
		return Pixel.new(random.rand(prevP.red-getQuantumRange(QuantumRange, 20)..prevP.red+getQuantumRange(QuantumRange, 20)), 
			random.rand(prevP.green-getQuantumRange(QuantumRange, 20)..prevP.green+getQuantumRange(QuantumRange, 20)), 
			random.rand(prevP.blue-getQuantumRange(QuantumRange, 20)..prevP.blue+getQuantumRange(QuantumRange, 20)), 1)
	end

	def linearDiagonal(random, x, y, base)
		return pureRandom(random, x, y, base) if y==0 || x==0
		prevP = base.pixel_color(x-1,y-1)
		return Pixel.new(random.rand(prevP.red-getQuantumRange(QuantumRange, 20)..prevP.red+getQuantumRange(QuantumRange, 20)), 
			random.rand(prevP.green-getQuantumRange(QuantumRange, 20)..prevP.green+getQuantumRange(QuantumRange, 20)), 
			random.rand(prevP.blue-getQuantumRange(QuantumRange, 20)..prevP.blue+getQuantumRange(QuantumRange, 20)), 1)
	end

	def blueScales(random, x, y, base)
		return Pixel.new(0, 0, QuantumRange, 1) if y==0
		prevP = base.pixel_color(x,y-1)

		nextBlue = random.rand(prevP.blue-getQuantumRange(QuantumRange, 4)..prevP.blue)

		return Pixel.new(prevP.red,
			prevP.green, 
			nextBlue, 1)
	end

	def verticalGradient(random, x, y, base)
		return Pixel.new(0, 0, QuantumRange, 1) if y==0
		prevP = base.pixel_color(x,y-1)

		nextBlue = random.rand(prevP.blue-getQuantumRange(QuantumRange, 225)..prevP.blue)
		nextBlue = 0 if nextBlue < 0

		return Pixel.new(prevP.red, prevP.green, nextBlue, 1)
	end

	def getQuantumRange(range, divider)
		return range/divider
	end

	def createBaseImage
		@base = Image.new(@width, @height){self.background_color = 'transparent'}
	end
end

test! if __FILE__==$0
