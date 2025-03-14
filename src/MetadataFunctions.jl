module MetadataFunctions

using MarkdownMetadata.MetadataClasses

export add_metadata, update_metadata, clear_metadata, update_category_name, remove_metadata

# initialize variable for function type checking
const allowed_types = get_allowed_types()

# add singular (category, value) pair
"""
    add_metadata(parent::MetadataContainer, key::MetadataCategory, value::Any)

Add singular MetadataCategory + value pair to MetadataContainer object.
"""
function add_metadata(parent::MetadataContainer, key::MetadataCategory, value::Any)
    keys = get_existing_keys(parent)
    if key.datatype != typeof(value)
        error("Value is of incorrect type. Expected type: $(key.datatype).")
    elseif key.name in keys
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
    keys = get_existing_keys(parent)
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
function add_metadata(parent::MetadataContainer, values::Vector{Pair{MetadataCategory, T}}) where T
    existing_keys = get_existing_keys(parent)
    
    for value in values
        category = first(value)
        val = last(value)
        if category.name in existing_keys
            error("Invalid key name: $(first(value)) category already exists in metadata.")
        elseif typeof(val) != category.datatype
            error("Invalid value type. Expected value of type $(category.datatype)")
        else
            push!(existing_keys, category.name)
        end
    end

    for value in values
        category = first(value)
        val = last(value)
        push!(parent.metadata, (category => val))
    end
end

# add multiple (category, value) pairs at once using string keys
"""
    add_metadata(parent::MetadataContainer, values::Vector{Pair{String, Any}})

Add multiple categorie + value pairs to MetadataContainer object using strings
"""
function add_metadata(parent::MetadataContainer, values::Vector{Pair{String, T}}) where T
    keys = get_existing_keys(parent)
    for value in values
        key = first(value)
        if key in keys
            error("Invalid key name: $(first(value)) category already exists in metadata.")
        else
            push!(keys, key)
        end
    end

    for value in values
        key = first(value)
        val = last(value)
        new_item = MetadataCategory(key, typeof(val))
        push!(parent.metadata, (new_item => val))
    end
            
end

# remove item
"""
    remove_metadata(parent::MetadataContainer, item::MetadataCategory)

Remove MetadataCategory from MetadataContainer.
"""
function remove_metadata(parent::MetadataContainer, item::MetadataCategory)
    index = findfirst(x -> first(x).name == item.name && first(x).datatype == item.datatype, parent.metadata)
    if !isnothing(index)
        deleteat!(parent.metadata, index)
    else
        error("Could not find category with name $(item.name) in MetadataContainer.")
    end
end

# remove item using string
"""
    remove_metadata(parent::MetadataContainer, item_name::String)    

Remove MetadataCategory from MetadataContainer using string name.
"""
function remove_metadata(parent::MetadataContainer, item_name::String)
    index = findfirst(x -> first(x).name == item_name, parent.metadata)
    if !isnothing(index)
        deleteat!(parent.metadata, index)
    else
        error("Could not find category with name $(item_name) in MetadataContainer.")
    end
end

# # remove multiple items
# function remove_metadata(parent::MetadataContainer, items::Vector{MetadataCategory})
# end

# # remove multiple items using string keys
# function remove_metadata(parent::MetadataContainer, items::Vector{String})
# end

# clear all pairs
"""
    clear_metadata(parent::MetadataContainer)

Removes all elements in MetadataContainer.
"""
function clear_metadata(parent::MetadataContainer)
    empty!(parent.metadata)
end

# update value associated with a category using raw data
"""
    update_metadata(parent::MetadataContainer, name::String, value::Any)

Update value in MetadataContainer object using associated string key.
"""
function update_metadata(parent::MetadataContainer, name::String, value::Any)
    occurences = [index for (index,item) in enumerate(parent.metadata) if first(item).name == name]
    if length(occurences) != 1
        error("An undetected error occured in the creation of metadata -- duplicate keys found. Please re-initialize metadata.")
    else
        key = first(parent.metadata[first(occurences)])
        if typeof(value) == key.datatype                        
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
    index = [index for (index, item) in enumerate(parent.metadata) if first(item).name == category.name]
    type = category.datatype
    if length(index) != 1
        error("A mistake was made. Found duplicate entries for key value $(category.name) in MetadataContainer")
    elseif typeof(value) != type
        error("Unexpected type $(typeof(value)). Expected value of type $type.")
    else
        # find correct category and update value
        parent.metadata[index[1]] =  (category => value)
    end
end

# update metadata key
"""
    update_category_name(parent::MetadataContainer, category::MetadataCategory, name::String)

Update key name of category in MetadataContainer.
"""
function update_category_name(parent::MetadataContainer, category::MetadataCategory, name::String)
    if contains(name, " ")
        error("Whitespace is not allowed in category name.")
    end
    
    index = findfirst(x -> first(x).name == category.name && first(x).datatype == category.datatype, parent.metadata)

    if  !isnothing(index)
        old_item = parent.metadata[index]
        new_item = MetadataCategory(name, first(old_item).datatype)
        parent.metadata[index] = (new_item => last(old_item))
    else
        error("Could not find $(category.name) in MetadataContainer.")
    end
end

"""
    update_category_name(parent::MetadataContainer, old_name::String, new_name::String)

Update key name of category in MetadataContainer using string name    
"""
function update_category_name(parent::MetadataContainer, old_name::String, new_name::String)
    if contains(new_name, " ")
        error("Whitespace is not allowed in category name.")
    end
    
    index = findfirst(x -> first(x).name == old_name, parent.metadata)

    if  !isnothing(index)
        old_item = parent.metadata[index]
        new_item = MetadataCategory(new_name, first(old_item).datatype)
        parent.metadata[index] = (new_item => last(old_item))
    else
        error("Could not find $(old_name) in MetadataContainer.")
    end

end

end
