module MetadataFunctions

using MarkdownMetadata.MetadataClasses

export add_metadata, update_metadata

# initialize variable for function type checking
const allowed_types = get_allowed_types()

# add singular (category, value) pair
"""
    add_metadata(parent::MetadataContainer, key::MetadataCategory, value::Any)

Add singular MetadataCategory + value pair to MetadataContainer object.
"""
function add_metadata(parent::MetadataContainer, key::MetadataCategory, value::Any)
    keys = first.(parent.metadata)
    if key.datatype != typeof(value)
        error("Value is of incorrect type. Expected type: $(key.datatype).")
    elseif key.name in [x.name for x in keys]
        error("Invalid key name: $(key.name) category already exists in metadata.")
    else
        push!(parent.metadata, (key => value))
    end
end

# add singular (category, value) pair using a string
"""
    add_metadata(parent::MetadataContainer, key::String, value::Any)

Add singular MetadataCategory + value pair to MetadataContainer object using String.
"""
function add_metadata(parent::MetadataContainer, key::String, value::Any)
    # check for duplicates
    keys = [x.name for x in first.(parent.metadata)]
    if key in keys
        error("Invalid key name: $(key) category alread exists in metadata.")
    else
        new_item = MetadataCategory(key, typeof(value))
        push!(parent.metadata, (new_item => value))
    end
end

# add multiple (category, value) pairs at once
"""
    add_metadata(parent::MetadataContainer, values::Vector{Pair{MetadataCategory, Any}})

Add multiple MetadataCategory + value pairs to MetadataContainer object.
"""
function add_metadata(parent::MetadataContainer, values::Vector{Pair{MetadataCategory, Any}})
    existing_keys = [x.name for x in first.(parent.metadata)]
    
    for value in values
        category = first(value)
        val = last(value)
        if category.name in existing_keys
            error("Invalid key name: $(first(value)) category already exists in metadata.")
        elseif typeof(val) != category.datatype
            error("Invalid value type. Expected value of type $(category.datatype)")
        else
            new_item = MetadataCategory(category.name, category.datatype)
            push!(parent.metadata, (new_item => val))
        end
    end
end

# # add multiple (category, value) pairs at once using string keys
# function add_metadata(parent::MetadataContainer, values::Vector{Pair{String, Any}})
# end

# # remove item
# function remove_metadata(parent::MetadataContainer, item::MetadataCategory)
# end

# # remove item using string
# function remove_metadata(parent::MetadataContainer, item::String)
# end

# # remove multiple items
# function remove_metadata(parent::MetadataContainer, items::Vector{MetadataCategory})
# end

# # remove multiple items using string keys
# function remove_metadata(parent::MetadataContainer, items::Vector{String})
# end

# # clear all pairs
# function clear_metadata(parent::MetadataContainer)
# end

# update value associated with a category using raw data
"""
    update_metadata(parent::MetadataContainer, name::String, value::Any)

Update value in MetadataContainer object using associated string key.
"""
function update_metadata(parent::MetadataContainer, name::String, value::Any)
    occurences = [index for (index,item) in enumerate(parent.metadata) if first(item.name) == name]
    if length(occurences) != 1
        error("An undetected error occured in the creation of metadata -- duplicate keys found. Please re-initialize metadata.")
    else
        key = parent.metadata[first(occurences)]
        if typeof(value) == last(key)                        
            new_pair = (key => value)
            parent.metadata[first(occurences)] = new_pair
        else
            error("Unexpected type $(typeof(value)). Expected value of type $(key.datatype).")
        end
    end
end

# update value associated with a category
"""
    update_metadata(parent::MetadataContainer, category::MetadataCategory, value::Any)

Update value in MetadataContainer object using associated MetadataCategory.
"""
function update_metadata(parent::MetadataContainer, category::MetadataCategory, value::Any)
    type = category.datatype
    if typeof(value) != type
        error("Unexpected type $(typeof(value)). Expected value of type $type.")
    else
        # find correct category and update value
        new_data = [first(item) == category ? category => value : item for item in parent.metadata]
        parent.metadata = new_data
    end
end

# function read_metadata(path::String)
# end



end
