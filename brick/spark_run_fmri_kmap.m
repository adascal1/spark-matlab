function [files_in,files_out,opt] = spark_run_fmri_kmap(files_in,files_out,opt)

%% This function takes input from the output of spark_run_fmri_Gx_clustering.m.
%% Output files: a k-hubness map (.mnc file), and a set of atom maps (.mnc file)

%% If the test flag is true, stop here !
if opt.flag_test == 1
    return
end


%% Thresholding the average coefficient matrix
load(files_in.data,'GX')
finalX       = GX;
imageSizeX=size(finalX,1);
imageSizeY=size(finalX,2);
test_dist=reshape(finalX,imageSizeX*imageSizeY,1);
[x,n]=hist(test_dist,100);
gmean=n(find(x == max(x)));
for w=1:1000
    subidx=randi([1 length(test_dist)], ceil(0.95*length(test_dist)),1);
    stds(w)=std(test_dist(subidx));
end;clear w
final_std=mean(stds);
X = norminv([opt.pvalue/2  1-opt.pvalue/2],gmean,final_std);
Xmask = abs(finalX) > max(abs(X));
thrfinalX= abs(finalX) .* Xmask;

%% remove atoms with small number of voxels
for i=1:size(thrfinalX,1)
   t(i)=nnz(thrfinalX(i,:));
end
thrfinalX(find(t<30),:)=[]; 

%% compute k-hubness
for ind=1: size(thrfinalX,2)
    opt_k(ind)=nnz(thrfinalX(:,ind));
end

isVolume = ~isempty(files_in.mask);

%% k-map generation
[k_map,hdr,opt_k, vol_mask] = spark_saveKmap(opt_k, files_in.mask, files_out, isVolume );


%% final atom maps 
atom_map = spark_saveAtoms(thrfinalX, files_in.mask, files_out, opt, isVolume );


%% Save all
save([opt.folder_out 'kmdl_nfGx_' opt.label.name '_p' num2str(opt.pvalue) '.mat']);
fprintf('%20s\n','...Completed')

