using FileIO
using Images
using Serialization
using Random
using CUDAapi
using Plots
import GR
using Images
using CuArrays
using ImageView
using Statistics, Random
import ProgressMeter
gr()
# Helper function to add path to array
function add_path(cat::String)
    temp_dir = readdir(joinpath(path,cat));
    return [joinpath(path, cat,x) for x in temp_dir],fill(cat,size(temp_dir,1) )
end
path = "/media/subhaditya/DATA/COSMO/Datasets/catDog/"
# Define number of threads
Threads.nthreads() = length(Sys.cpu_info())

"""
Function to create an array of images and labels -> when the directory structure is as follows
- main
    - category1
        - file1...
    -category2
        - file1...
    ...
"""
function fromFolder(path::String,imageSize=64::Int64)
    @info path, imageSize
    categories = readdir(path)
    total_files = collect(Iterators.flatten([add_path(x)[1] for x in categories]));
    total_categories = collect(Iterators.flatten([add_path(x)[2] for x in categories]));

    images = zeros((imageSize, imageSize, 3, size(total_files,1)));

    Threads.@threads for idx in 1:size(total_files,1)
        img = channelview(imresize(load(total_files[idx]), (imageSize, imageSize)))
        img = convert(Array{Float64},img)
        images[:,:,:,idx] = permutedims(img,(2,3,1))
        end
    @info "Done loading images"
    return images, total_categories
    

end
    
# test
X,y = fromFolder(path,64);
