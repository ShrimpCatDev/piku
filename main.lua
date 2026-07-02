shove=require("lib/shove")
lg=love.graphics

function lerp(from, to, speed, dt)
    return from + (to - from) * math.min(speed * dt, 1)
end

function love.load()
    conf=require("conf")
    shove.setResolution(conf.gw,conf.gh,{renderMode = "layer" ,scalingFilter = "nearest"})
    shove.setWindowMode(conf.ww,conf.wh,{resizable=true})
    shove.createLayer("screen")
    love.graphics.setDefaultFilter("nearest","nearest")

    font=love.graphics.newFont("assets/monogram.ttf",16)
    love.graphics.setFont(font)

    pal=require("lib/pal")
    pal:new("waft",love.image.newImageData("assets/waft.png"))
    pal:load("waft")

    assets={
        xmbIcon=lg.newImage("assets/blankXmb.png"),
        bg=lg.newImage("assets/bg.png")
    }
    menu={
        items={
            {name="Super Mario World"},
            {name="EarthBound"},
            {name="Animal Crossing Wild World"}
        },
        x=16,
        y=conf.gh/2-(assets.xmbIcon:getHeight()/2),
        gy=0,
        dy=0,
        selected=0
    }
end

function love.update(dt)
    local y=menu.y-((menu.selected)*(assets.xmbIcon:getHeight()+16))
    menu.dy=lerp(menu.dy,y,10,dt)
end

function love.draw()
    shove.beginDraw()
        shove.beginLayer("screen")
            lg.draw(assets.bg)
            --lg.rectangle("fill",72,menu.y-4,80,100)
            lg.setColor(pal:color(0))
            love.graphics.printf(menu.items[menu.selected+1].name,72,menu.y-4,80,"left")

            lg.push()
            lg.translate(0,math.floor(menu.dy))
                for k,v in ipairs(menu.items) do
                    local y=(k-1)*(assets.xmbIcon:getHeight()+16)
                    lg.setColor(pal:color(0))
                    lg.rectangle("fill",menu.x-3,y-3,assets.xmbIcon:getWidth()+6,assets.xmbIcon:getHeight()+6,2,2)
                    lg.setColor(1,1,1,1)
                    lg.draw(assets.xmbIcon,16,y)
                end
            lg.translate(0,0)
            lg.pop()
        shove.endLayer()
    shove.endDraw()
end

function love.keypressed(k)
    if k=="up" then
        menu.selected=menu.selected-1
        if menu.selected<0 then
            menu.selected=#menu.items-1
        end
    end
    if k=="down" then
        menu.selected=menu.selected+1
        if menu.selected>=#menu.items then
            menu.selected=0
        end
    end
end