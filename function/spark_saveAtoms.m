function atom_map = spark_saveAtoms(thrfinalX, mask, files_out, opt, isVolume )
%SPARK_SAVEATOMS Summary of this function goes here
%   Detailed explanation goes here
    
    [path_f,name_f,ext_f] = niak_fileparts(files_out.kmaps); 

    if isVolume
        [hdr,vol_mask] = niak_read_vol(mask);
    end

    atom_map = cell(1,size(thrfinalX,1));

    for i=1:size(thrfinalX,1)

        atom        = thrfinalX(i,:);
        file_name   = fullfile(opt.folder_out, ['atom' num2str(i) '_',opt.label.name ext_f]);

        if isVolume
            atom_map{i} = niak_tseries2vol(atom,vol_mask);

            hdr.file_name = file_name;
            niak_write_vol(hdr,atom_map{i});
        else
            atom_map{i} = atom;

            surf = gifti();
            surf.cdata = atom_map{i};
            save  (surf,file_name)
        end
    end

    % Save output files
    if ~strcmp(files_out.atoms_all_mat,'gb_niak_omitted')
        hdr.file_name = '';
        save(files_out.atoms_all_mat, 'atom_map','hdr');
    end

end

