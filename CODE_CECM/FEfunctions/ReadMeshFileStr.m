function MESH=    ReadMeshFileStr(nameMSH,varargin)
%%% read .msh
% J.A. Hernandez
% % JAHO_B
% warning('JAHO_B')
% load('/home/joaquin/USO_COMUN_MATLAB/DATA/jaho.mat')
%dbstop('9')
% Same as ReadMeshFile, but the output is a structure array
if nargin == 0
    load('tmp.mat')
end
% INPUTS
READ_MATERIAL_COLUMN  = 0;
%% EXTRACTING INPUTS
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varginOR = varargin ;
FdnamesInputs = {'READ_MATERIAL_COLUMN'};
AuxDATA=WriteAuxFdNamesNEW(FdnamesInputs,varginOR);
for id = 1:length(AuxDATA);
    eval(AuxDATA{id});
end
%E_JAHO


%3) Open file
if strcmp(nameMSH(end-3:end),'.msh') == 0
    nameMSH = [nameMSH,'.msh'];
end

fid=fopen(nameMSH,'r');

% First Read
%%%%%%%%%%%%
[OkFindRes RestLine] = ReadUntilToken(fid,'MESH'); % Find word "MESH"
% Data of the first mesh
[NameMesh1,ndime1,TypeElement1,nnode_elem1]=ObtInfMsh(RestLine);
%ndime1 = 3;
%nnode_elem1 = 4 ;
leido=fscanf(fid,'%s',1); %read "coordinates"
[OkFindRes ,num_nodos1] = ReadUntCount(fid,'end',ndime1+1) ;% counting nodes of mesh 1
[OkFindRes RestLine] = ReadUntilToken(fid,'Elements');
%leido=fscanf(fid,'%s',2); % read "coordinates" and "elements"
[OkFindRes ,num_elementos_1] = ReadUntCount(fid,'End',nnode_elem1+1+READ_MATERIAL_COLUMN); %% counting elements of mesh 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   boundary mesh
[OkFindRes RestLine] = ReadUntilToken(fid,'MESH'); % Find word "MESH"
if OkFindRes == 1
    % Data of the first mesh
    [NameMesh1,ndime1,TypeElementBOUND,nnode_elemBOUND]=ObtInfMsh(RestLine);
    [OkFindRes RestLine] = ReadUntilToken(fid,'Elements');
    
    %leido=fscanf(fid,'%s',2); % read "coordinates" and "elements"
    [OkFindRes ,num_elementosBOUND] = ReadUntCount(fid,'End',nnode_elemBOUND+1); %% counting elements of mesh 1
else
    % % there's no second mesh
    num_elementosBOUND = 0 ;
    TypeElementBOUND = [] ;
    nnode_elemBOUND = 0 ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Global Arrays
nmeshes = 1;
NameMeshes ={NameMesh1};
ndim       = ndime1;
nnode_elem = nnode_elem1;
num_elementos = num_elementos_1;
num_nodos = [num_nodos1];
%
%
% fclose(fid);
%
% % End of first lecture
%
% %%%%%%%% For storing information (structure)
%
% coordenadas = InitStrucField(NameMeshes,num_nodos,ndim+1);
% conexiones  = InitStrucField(NameMeshes,num_elementos,nnode_elem+1);
% material    = InitStrucField(NameMeshes,num_elementos,2*ones(nmeshes,1));

% Second lecture (storing)
fid=fopen(nameMSH,'r');
%% Lectura elementos y material(malla 1)
imesh = 1;
[OkFindRes RestLine] = ReadUntilToken(fid,'MESH');

% Coord
leido=fscanf(fid,'%s',1);  % read "coordinates"
COOR=leer_fichero_colum('',ndim(imesh)+1,0,num_nodos(imesh),0,0,fid);

COOR = COOR(:,2:end) ;
if ~any(COOR(:,end)-COOR(1,end))
    COOR = COOR(:,1:end-1);
end

% Conex
%dummy=fscanf(fid,'%s',3); % read "end coordinates" and "elements"
[OkFindRes RestLine] = ReadUntilToken(fid,'Elements');
CONNECT=leer_fichero_colum('',nnode_elem(imesh)+1+READ_MATERIAL_COLUMN,0,num_elementos(imesh),0,0,fid);
CONNECT = CONNECT(:,2:end) ;

if READ_MATERIAL_COLUMN == 1
    MaterialType =  CONNECT(:,end) ;
    CONNECT = CONNECT(:,1:end-1) ;
else
    MaterialType = [] ;
end

%
%% Boundary mesh
imesh = 1;
if num_elementosBOUND > 0
    [OkFindRes RestLine] = ReadUntilToken(fid,'MESH');
    
    % % Coord
    % leido=fscanf(fid,'%s',1);  % read "coordinates"
    % COOR=leer_fichero_colum('',ndim(imesh)+1,0,num_nodos(imesh),0,0,fid);
    
    % Conex
    %dummy=fscanf(fid,'%s',3); % read "end coordinates" and "elements"
    [OkFindRes RestLine] = ReadUntilToken(fid,'Elements');
    CONNECTbound=leer_fichero_colum('',nnode_elemBOUND+1,0,num_elementosBOUND,0,0,fid);
    CONNECTbound = CONNECTbound(:,2:end) ;
else
    CONNECTbound = [] ;
    
end
% Jan-7-2019. Removing repeated elements  (if any. Not strictly necessary)
%CONNECTbNonRepeated = CheckCONNECTbNONrepeated(CONNECTbound) ;


fclose(fid);

% 9-April-2019 --> Remove nodes which are not used in the CN matrix 
% 
% %CNrenumbered = RenumberConnectivities(CN,NODES)
% nCOOR = size(COOR,1) ;
% nCN = length(unique(CONNECT));
% if nCOOR ~= nCN
%     NodesBefore = unique(CONNECT) ;
%     COOR =  COOR(NodesBefore,:) ;
%     CONNECT = RenumberConnectivities(CONNECT,1:nCN);
%     NODESbndBefore = unique(CONNECTbound) ;
%     [~,NODES_bnd,~] = intersect(NodesBefore,NODESbndBefore) ;
%     CONNECTbound= RenumberConnectivities(CONNECTbound,NODES_bnd) ;
% end

%% Remove repeated connectivities  (this was disabled  until 16-June-2019)
CONNECTb_old = CONNECTbound; 
CONNECTbound = RemoveREpeatedConnectivities(CONNECTbound)  ;

if size(CONNECTbound,1) ~= size(CONNECTb_old,1)
    warning('Ill-constructed Boundary COnnectivity Matrix. REmoving repeated elements. ')
end



MESH.COOR = COOR;
MESH.CN = CONNECT;
MESH.TypeElement = TypeElement1 ;
MESH.CNb = CONNECTbound;
MESH.TypeElementB = TypeElementBOUND;

 

MESH.MaterialType = MaterialType ;
