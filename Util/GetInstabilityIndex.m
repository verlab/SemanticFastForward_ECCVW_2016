%% It calculates the instability index of the video according to (Silva et al., 2016)
function Instability = GetInstabilityIndex(video_filename, buffer_size, range)
addpath('../');

%% Reading input and Creating the output
fprintf('%sLoading the input video: %s...\n', log_line_prefix, video_filename);
video = VideoReader(video_filename);
buffer = zeros(buffer_size, video.Height, video.Width);

if nargin < 3 % OK! We can read frame by frame of the video
    fprintf('%sProcessing, please wait...\n', log_line_prefix);
    %% Pre-loading stage (fills up the buffer)
    for i=1:buffer_size
        buffer(i,:,:) = double(rgb2gray(readFrame(video)));
    end

    buffers_std_sum = std(buffer);

    i = buffer_size;
    while(hasFrame(video))
        buffer(mod(i, buffer_size)+1,:,:) = double(rgb2gray(readFrame(video)));

        buffers_std_sum = buffers_std_sum + std(buffer);

        if(mod(i, 100) == 0)
            fprintf('%s%d frames processed...\n', log_line_prefix, i);
        end

        i = i + 1;% Increment
    end
else % We gotta know the number of frames to iterate   
    fprintf('%sLoading video...\n', log_line_prefix);
    num_frames = video.NumberOfFrames;
    fprintf('%sVideo loaded...\n', log_line_prefix);
    
    range_min = range(1);
    range_max = range(2);
    
    %% Pre-loading stage (fills up the buffer)
    for i=1:buffer_size
        buffer(i,:,:) = double(rgb2gray(read(video, i+range_min-1)));
    end

    buffers_std_sum = std(buffer);

    i = buffer_size;
    for j=range_min+buffer_size:range_max
        buffer(mod(i, buffer_size)+1,:,:) = double(rgb2gray(read(video, j)));

        buffers_std_sum = buffers_std_sum + std(buffer);

        if(mod(j, 100) == 0)
            fprintf('%s%d frames processed...\n', log_line_prefix, j);
        end

        i = i + 1;% Increment
    end
end

Instability = mean(mean(squeeze(buffers_std_sum./(i-buffer_size))));

end