require 'sinatra'
require 'date'

set :environment, :production

get '/:y/:m' do
  @year = params[:y].to_i
  @month = params[:m].to_i

  @y1 = @year
  @m1 = @month - 1
  if @m1 == 0
    @m1 = 12
    @y1 = @y1 - 1
  end

  @y2 = @year
  @m2 = @month + 1
  if @m2 == 13
    @m2 = 1
    @y2 = @y2 + 1
  end

  @t = "<table border>"
  @t = @t + "<tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th>"
  @t = @t + "<th>Thu</th><th>Fri</th><th>Sat</th></tr>"

  l = getLastDay(@year, @month)
  h = zeller(@year, @month, 1)

  d = 1
  6.times do |p|
    @t = @t + "<tr>"
    7.times do |q|
      if p == 0 && q < h
        @t = @t + "<td></td>"
      else
        if d <= l
          @t = @t + "<td align=\"right\">#{d}</td>"
          d += 1
        else
          @t = @t + "<td></td>"
        end
      end
    end
    @t = @t + "</tr>"
    if d > l
      break
    end
  end

  @t = @t + "</table>"

  erb :moncal
end

get '/' do
  today = Time.now
  y = today.year
  m = today.month
  redirect "http://127.0.0.1:4567/#{y}/#{m}"
end

def isLeapYear(y)
  if y % 4 == 0
    return true
  elsif y % 400 == 0
    return true
  elsif y % 100 == 0
    return false
  else
    return false
  end
end

def getLastDay(y, m)
  a = Date.new(y, m, -1)
  return a.day
end

def zeller(y, m, d)
  b = y + (y/4) - (y/100) + (y/400) + ((13*m) + 8)/5 + d
  c = b%7
  return c
end

