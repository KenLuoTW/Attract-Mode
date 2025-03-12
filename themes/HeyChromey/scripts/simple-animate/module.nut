//The interpolate module is needed to control the interpolation of the animations
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/simple-animate/interpolate.nut" );
//fe.load_module("simple-animate/interpolate");

/*
Animates the values of the properties of an object.
*/
class SimpleAnimation extends InterpolableTriggerBase
{
    object = null;
	objx = null;
	objy = null;
	objw = null;
	objh = null;
    blocking = false;
	loop = false;

    constructor(lapse, animable_object, configuration = null, is_blocking = false)
    {
        object = animable_object;
		objx = object.x;
		objy = object.y;
		objw = object.width;
		objh = object.height;
        setup_config(configuration);
        if(!("interpolation" in config)) config.interpolation <- interpolations.linear;
		if(!("loop" in config)) config.loop <- false;
		loop = config.loop;
        blocking = is_blocking;
        tlapse = lapse;
    }

    function play(func = null)
    {
		loop = config.loop;
        setup_onstoponce(func);
        add_to_loop();
    }

    function finish()
    {
        remove_from_loop();
    }

    function setup_properties(prop)
    {
        if("properties" in config) config.properties = prop;
        else config.properties <- prop;
    }
    
    function update(ttime)
    {
        if(!("properties" in config)) return true;
		if(config.loop != loop) config.loop <- loop;
        foreach(key, value in config.properties) {
			switch(key) {
				case "pulse":
					object.width = objw * animate(value.start, value.end, ttime);
					object.height = objh * animate(value.start, value.end, ttime);
					object.x = objx + ( objw / 2 - object.width /2 );
					object.y = objy + ( objh / 2 - object.height / 2 );
					break;
				default:
					object[key] = animate(value.start, value.end, ttime);
					break;
			}
		}
        return base.update(ttime);
    }

    function stop()
    {
        return base.stop();
    }

    function animate(start, end, ttime)
    {
        return start + ((end - start) * config.interpolation(minmax(normalize(ttime - tstart, tlapse))));
    }

    function normalize(elapsed, lapse)
    {
        local result = elapsed / lapse.tofloat();
        return result;
    }
    
    function minmax(value, min = 0.0, max = 1.0)
    {
        if(min > value) value = min;
        if(max < value) value = max;
        return value;
    }
}

class AnimatedSprite extends InterpolableTriggerBase
{
    sprite = null;
    current_animation = null;
    blocking = false;

    constructor(atlas, configuration, is_blocking = false)
    {
        setup_config(configuration);
        sprite = atlas;
        sprite.subimg_width = config.sprite_width;
        sprite.subimg_height = config.sprite_height;
        blocking = is_blocking;
    }

    function play(func = null)
    {
        play(null, func);
    }

    function play(animation = null, func = null)
    {
        if(animation == null) foreach(key, value in config.animations) { animation = key; break; }
        current_animation = config.animations[animation];
        
        tlapse = (current_animation.sequence.len() * 1000 /  current_animation.fps).tointeger();
        
        setup_onstoponce(func);
        add_to_loop();
    }

    function finish(frame = null)
    {
        remove_from_loop();
        if(frame != null) set_sprite(frame);
    }

    function update(ttime)
    {
        if(!current_animation.loop && base.update(ttime)) return true;

        local frame = current_animation.sequence[(((ttime - tstart) % tlapse) * current_animation.fps / 1000).tointeger()];
        set_sprite(frame);
        return false;
    }

    function setup_sequence(sequence)
    {
        if(sequence == null || sequence.len() == 0)
        {
            sequence = [];
            local len = (sprite.texture_width / sprite.subimg_width) * (sprite.texture_height / sprite.subimg_height);
            for(local i = 0; i < len; i++) sequence.append(i);
        }
        return sequence;
    }

    function set_sprite(frame)
    {
        local frames_per_row = sprite.texture_width / sprite.subimg_width;
        sprite.subimg_x = sprite.subimg_width * (frame % frames_per_row);
        sprite.subimg_y = sprite.subimg_height * (frame / frames_per_row);
    }
}

/*
Returns <true> if there is a blocking interpolable object being interpolated.
*/
function blocking_animations_running()
{
    foreach(interpolable in interpolator.interpolables)
    {
        if("blocking" in interpolable && interpolable.blocking) return true;
    }
    return false;
}