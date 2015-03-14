%% DEMO CODE

num_images = 29;
base_name = 'demo/demo (';
end_name = ').jpg';

r = randperm(num_images);
count = 1;
for i=r
    fprintf('\nObject #%d\n', count);
    image = imread(char(strcat(base_name, num2str(i), end_name)));
    imshow(image);
    demo_classifier(image);
    fprintf('Please hit enter to continue\n\n\n');
    pause;
    count = count + 1;
end