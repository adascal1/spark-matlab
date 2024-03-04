function [k_map,hdr,opt_k, vol_mask] = spark_saveKmap(opt_k, mask, files_out, isVolume )
%SPARK_SAVEDATA Summary of this function goes here
%   Detailed explanation goes here


    if isVolume

        [hdr,vol_mask] = niak_read_vol(mask);
        vol_mask = round(vol_mask);
        k_map = niak_tseries2vol(opt_k,vol_mask);
    
        [~,~,ext_f] = niak_fileparts(files_out.kmaps);  
        hdr.type = ext_f;
        hdr.file_name = files_out.kmaps;
        niak_write_vol(hdr,k_map);

    else
        k_map = opt_k;
        vol_mask = [];
        
        surf = gifti();
        surf.cdata = opt_k;
        save  (surf,files_out.kmaps)
    end

    % Save output files
    if ~strcmp(files_out.kmap_all_mat,'gb_niak_omitted')
        hdr.file_name = '';
        save(files_out.kmap_all_mat, 'k_map','hdr','opt_k');
    end

end

