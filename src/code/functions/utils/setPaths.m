function Path = setPaths(proj)
	%% Creates a structure with all the Matlab-relevant paths.
	% The name of each field corresponds to the last folder in the project path.
	%
	% Rationale:
	% - We iterate over ALL entries in proj.ProjectPath and add them to Path.
	% - Any paths *under* vendor/** or functions/** are intentionally skipped.
	% - Only the top-level 'vendor' and top-level 'functions' folders are kept.
	% *Use: Path = setPaths(proj)
	% *Input*: (proj) Matlab project structure
	% *Output: structure with fields named as the folders.

	Path.root = proj.RootFolder;
	Path.dist = fullfile(Path.root, 'dist');

	vendor_marker = [filesep 'vendor' filesep];
	functions_marker = [filesep 'functions' filesep];

	for i = 1:length(proj.ProjectPath)
		look = proj.ProjectPath(i).File;
		if isempty(look) || strcmp(look, Path.root)
			continue
		end

		out = split(look, filesep);
		leaf = out{end};

		% Skip anything inside vendor/** except the vendor root itself
		if contains(look, vendor_marker) && ~strcmp(leaf, 'vendor')
			continue
		end

		% Skip anything inside functions/** except the functions root itself
		if contains(look, functions_marker) && ~strcmp(leaf, 'functions')
			continue
		end

		Path.(leaf) = look;
	end
end