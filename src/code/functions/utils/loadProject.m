function out= loadProject(path, project_name) 
%% Load the matlab project to make all routes relative to the root folder
	cd(path)
	% Load the MATLAB project
	try
		proj = currentProject;
		tt = split(project_name,filesep);
		if ~strcmp(proj.Name, tt{end})
			openProject(project_name+".prj")
			try 
				commandwindow  
			catch
			end
		end
	catch
		openProject(project_name+".prj")
		try 
			commandwindow 
		catch
		end
		proj = currentProject;
	end
end