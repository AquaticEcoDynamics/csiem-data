function ssh2_struct = sftp_put(ssh2_struct, localFilename, remotePath, localPath, remoteFilename)
%  SFTP_PUT   Reuse configured ssh2_connection to SFP local files to remote
%             host.
%
%   SFTP_PUT(SSH2_CONN,LOCALFILENAME,[REMOTEPATH],[LOCALPATH],[REMOTEFILENAME])
%   uses a ssh2_connection and uploads the LOCALFILENAME to the remote
%   host using SFTP. SSH2_CONN must already be confgured using 
%   ssh2_config or ssh2_config_publickey.
%
%   LOCALFILENAME can be either a single string, or a cell array of strings. 
%   If LOCALFILENAME is a cell array, all files will be downloaded
%   sequentially.
%
%   OPTIONAL INPUTS:
%   -----------------------------------------------------------------------
%   REMOTEPATH specifies a specific path to upload the file to. Otherwise, 
%   the default (home) folder is used.
%   LOCALPATH specifies the folder to find the LOCALFILENAME in the file
%   is outside the working directory.
%   REMOTEFILENAME can be specified to rename the file on the remote host.
%   If LOCALFILENAME is a cell array, REMOTEFILENAME must be too.
%
%   SFTP_PUT returns the SSH2_CONN for future use.
%
%see also sftp_get, sftp_simple_get, sftp_simple_put, sftp
%
% (c)2011 Boston University - ECE
%    David Scott Freedman (dfreedma@bu.edu)
%    Version 2.0

if nargin < 2
    if nargin == 0
        ssh2_struct = [];
    end
    help sftp_put
else
    if nargin < 3
        remotePath = '';
    end
    
    if nargin < 4
        localPath = pwd();
    elseif isempty(localPath)
        localPath = pwd();   
    end    
    
    if nargin >= 5
        ssh2_struct.remote_file_new_name = remoteFilename;
    else 
        remoteFilename = [];
    end
    
    ssh2_struct.sendfiles = 1;
    ssh2_struct.local_file = localFilename;
    ssh2_struct.local_target_direcory = localPath;
    ssh2_struct.remote_target_direcory = remotePath;

    ssh2_struct = sftp(ssh2_struct);
end