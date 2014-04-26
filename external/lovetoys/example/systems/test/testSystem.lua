function table.count(list) 
    local counter = 0
    for index, value in pairs(list) do
        counter = counter + 1
    end
    return counter
end

TestSystem = class("TestSystem", System)

function TestSystem:fireEvent(event)
    if (event.key == "t") then
        print("Test is Starting")
        multi = MultipleRequirementsSystem()
        engine:addSystem(multi)

        newEntities = {}

        print("Entities before adding: ")
        multi:printStuff()
        
        print("Adding test entities 1")
        for i = 1, 15, 1 do
            entity = Entity()
            entity:add(TimeComponent())
            engine:addEntity(entity)
            table.insert(newEntities, entity)
        end

        print("Adding test entities 2")
        for i = 1, 5, 1 do
            entity = Entity()
            entity:add(PositionComponent(100, 20*i))
            engine:addEntity(entity)
            table.insert(newEntities, entity)
        end

        print("Entities after adding: ")
        multi:printStuff()
        print("Removing system")
        engine:removeSystem("MultipleRequirementsSystem")
        print("Adding system again")
        engine:addSystem(multi)
        multi:printStuff()
        
        print("Removing all the stuff")
        for index, value in pairs(newEntities) do
            engine:removeEntity(value)
        end
        multi:printStuff()

        engine:removeSystem("MultipleRequirementsSystem")

        print("Test ending")
    end
end



