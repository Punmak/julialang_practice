using HorizonSideRobots
HSR = HorizonSideRobots

function HSR.move!(robot::Robot, sides::Tuple{HorizonSide, HorizonSide})
    move!(sides[0])
    move!(sides[1])
end

function move_to_side!(robot::Robot, side::HorizonSide) :: Integer
    count_steps::Integer = 0
    while !isborder(robot, side)
        move!(robot, side)
        count_steps += 1
    end
    return count_steps
end

function move_and_mark!(robot::Robot, side::HorizonSide)
    while !isborder(robot, side)
		putmarker!(robot)
		move!(robot, side)
    end
end

function move_count_steps!(robot::Robot, side::HorizonSide, count_steps::Integer)
    for _ in range count_steps
        move!(robot, side)
    end
end

function move_to_corner!(robot::Robot, sides::Tuple{HorizonSide, HorizonSide})
    steps_to_corner = [0, 0]
    counter = 1
    for side in sides
		steps_to_corner[counter] = move_to_side!(robot, side)
		counter += 1
    end
    return steps_to_corner
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side) + 2, 4))

inverse(sides::Tuple{HorizonSide, HorizonSide}) = inverse.(sides)

function marker_crest!(robot::Robot)
    move_to_corner!(robot, (West, Sud))
    count_steps_x = move_to_side!(robot, Ost)
    count_steps_y = move_to_side!(robot, Nord)
    center :: Tuple{Integer, Integer} = (count_steps_x / 2 + 1, count_steps_y // 2 + 1)
    move_count_steps!(robot, West, center[0])
    move_count_steps!(robot, Sud, center[1])
    for side in (Nord, West, Sud, Ost)
		move_and_mark!(robot, side)
		while ismarker(robot)
			move!(robot, inverse(side))
		end
    end
    putmarker!(robot)
end

function marker_perimetr!(robot::Robot)
    move_to_corner!(robot, (West, Sud))
    for side in (Nord, Ost, Sud, West)
		move_and_mark!(robot, side)
    end
end
