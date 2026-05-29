function [L, COMP, methode2] = dltcalib8_stitching(XY, methode, UV1, varargin);


%[L,COMP,methode] = dltcalib8(XY, methode, UV, varargin)
%
%Script permettant le calcul des coefficients de la DLT 2D selon
%différentes méthode de résolution mathématique.
%
%Variables d'entrée:
%       XY: Coordonnées métriques des mires de calibration
%           Exemple:
%              Mire 1     Xm1  Ym1
%              Mire 2     Xm2  Ym2
%               ...         ...
%              Mire m     Xmm  Ymm
%
%       methode: Choix de la méthode de calcul des coefficients de la DLT.
%           Optimale: Le script choisit la méthode optimale (diminution de l'erreur de reprojection 
%                au sens des moindres carrés) pour chaque caméra (par defaut).
%           SVD_NO_TA: Décomposition par valeur singulière + Transformation affine + Optimisation non-linéaire.
%           SVD_NO_NT: Décomposition par valeur singulière + Sans transformation + Optimisation non-linéaire.
%           SVD_O_TA: Décomposition par valeur singulière + Transformation affine + Optimisation non-linéaire.
%           SVD_O_NT: Décomposition par valeur singulière + Sans transformation affine + Optimisation non-linéaire.
%           Autres options: Idem mais en remplaçant SVD par MC pour avoir une méthode des moindres carrés.
%
%           A noter: Méthode classique: MC_NO_NT.
%
%       UV1: Coordonnées pixels dans la caméra 1 des mires de calibration.
%           Exemple:
%                  Um1  Vm1  Um2  Vm2   ...   Umn  Vmn
%
%       Varargin: Idem pour les coordonnées pixels des éventuelles autres
%           caméras
%
%Variables de sortie:
%       L: Coefficients de la DLT pour chaque caméra.
%           Exemple:
%                   Caméra a ... Caméra n
%                     L1a    ...    L1n
%                     ...    ...    ...
%                     L8a    ...    L8n
%
%       COMP: Reconstruction du comparateur et calcul des résidus.
%           Exemple:
%               Mire 1   Xr1   Yr1    Res1
%               Mire 2   Xr2   Yr2    Res2
%                    ...     ...     ...    
%               Mire m   Xrm   Yrm    Resm
%                       ResX  ResY    Moyenne
%
%       methode: Méthode utilisée pour le calcul des coefficients.
%
%Copyright (c), Marc Elipot
%Janvier 2008.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% CONDITIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L = 1;
COMP = 1;
methode2 = 1;

%---Vérification du bon nombre des variables
nbvarargin = length(varargin);
nbvar = nargin - nbvarargin;

if nbvar < 3;
    return;
end;

%---Modification du nom des variables dans varargin
for i = 1:nbvarargin;
    eval(['UV' num2str(i+1) ' = varargin{' num2str(i) '};']);
end;
ncam = nargin - 2;

[nbm,RIEN] = size(XY);

%---------------Transformation du format des fichiers tracking-------------
%--------------------------------------------------------------------------
[li,co] = size(UV1);
for j = 1:ncam;
    for i = 1:2:co;
        eval(['UVb(1,(' num2str(i) '+1)/2) = UV' num2str(j) '(1,' num2str(i) ');']);
        eval(['UVb(2,(' num2str(i) '+1)/2) = UV' num2str(j) '(1,(' num2str(i) '+1));']);
    end;
    eval(['UV' num2str(j) ' = UVb;']);
end;

if strcmpi(methode, 'MC_NO_NT');
    texte = ['XY'];
    for i = 1:ncam;
        texte = [texte ', UV' num2str(i)];
    end;
    eval(['[COMP, L] = MC_NO_NT(' texte ');']);
    methode2 = 'MC_NO_NT';

elseif strcmpi(methode, 'SVD_NO_NT');
    texte = ['XY'];
    for i = 1:ncam;
        texte = [texte ', UV' num2str(i)];
    end;
    eval(['[COMP, L] = SVD_NO_NT(' texte ');']);
    methode2 = 'SVD_NO_NT';

elseif strcmpi(methode, 'MC_O_NT');
    texte = ['XY'];
    for i = 1:ncam;
        texte = [texte ', UV' num2str(i)];
    end;
    eval(['[COMP, L] = MC_O_NT(' texte ');']);
    methode2 = 'MC_O_NT';

elseif strcmpi(methode, 'SVD_O_NT');
    texte = ['XY'];
    for i = 1:ncam;
        texte = [texte ', UV' num2str(i)];
    end;
    eval(['[COMP, L] = SVD_O_NT(' texte ');']);
    methode2 = 'SVD_O_NT';
    
elseif strcmpi(methode, 'MC_NO_TA');
    texte = ['XY'];
    for i = 1:ncam;
        texte = [texte ', UV' num2str(i)];
    end;
    eval(['[COMP, L] = MC_NO_TA(' texte ');']);
    methode2 = 'MC_NO_TA';

elseif strcmpi(methode, 'SVD_NO_TA');
    texte = ['XY'];
    for i = 1:ncam;
        texte = [texte ', UV' num2str(i)];
    end;
    eval(['[COMP, L] = SVD_NO_TA(' texte ');']);
    methode2 = 'SVD_SVD_TA';

elseif strcmpi(methode, 'MC_O_TA');
    texte = ['XY'];
    for i = 1:ncam;
        texte = [texte ', UV' num2str(i)];
    end;
    eval(['[COMP, L] = MC_O_TA(' texte ');']);
    methode2 = 'MC_O_TA';

elseif strcmpi(methode, 'SVD_O_TA');
    texte = ['XY'];
    for i = 1:ncam;
        texte = [texte ', UV' num2str(i)];
    end;
    eval(['[COMP, L] = SVD_O_TA(' texte ');']);
    methode2 = 'SVD_O_TA';

elseif strcmpi(methode, 'Optimal');
    texte = ['XY'];
    for i = 1:ncam;
        texte = [texte ', UV' num2str(i)];
    end;
    eval(['[C_MC_NO_NT, L_MC_NO_NT] = MC_NO_NT(' texte ');']);
    eval(['[C_SVD_NO_NT, L_SVD_NO_NT] = SVD_NO_NT(' texte ');']);
    eval(['[C_MC_O_NT, L_MC_O_NT] = MC_O_NT(' texte ');']);
    eval(['[C_SVD_O_NT, L_SVD_O_NT] = SVD_O_NT(' texte ');']);
    eval(['[C_MC_NO_TA, L_MC_NO_TA] = MC_NO_TA(' texte ');']);
    eval(['[C_SVD_NO_TA, L_SVD_NO_TA] = SVD_NO_TA(' texte ');']);
    eval(['[C_MC_O_TA, L_MC_O_TA] = MC_O_TA(' texte ');']);
    eval(['[C_SVD_O_TA, L_SVD_O_TA] = SVD_O_TA(' texte ');']);
    
    C_tot = [C_MC_NO_NT(nbm+1,3); C_SVD_NO_NT(nbm+1,3); C_MC_O_NT(nbm+1,3); C_SVD_O_NT(nbm+1,3); ...
             C_MC_NO_TA(nbm+1,3); C_SVD_NO_TA(nbm+1,3); C_MC_O_TA(nbm+1,3); C_SVD_O_TA(nbm+1,3)];
    
    li = find(C_tot == min(C_tot));
    if length(li) ~= 1;
        li = li(1,1);
    end;
    
    if li == 1;
        COMP = C_MC_NO_NT;
        L = L_MC_NO_NT;
        methode2 = 'MC_NO_NT';
        
    elseif li == 2;
        COMP = C_SVD_NO_NT;
        L = L_SVD_NO_NT;
        methode2 = 'SVD_NO_NT';
        
    elseif li == 3;
        COMP = C_MC_O_NT;
        L = L_MC_O_NT;
        methode2 = 'MC_O_NT';
        
    elseif li == 4;
        COMP = C_SVD_O_NT;
        L = L_SVD_O_NT;
        methode2 = 'SVD_O_NT';
        
    elseif li == 5;
        COMP = C_MC_NO_TA;
        L = L_MC_NO_TA;
        methode2 = 'MC_NO_TA';
        
    elseif li == 6;
        COMP = C_SVD_NO_TA;
        L = L_SVD_NO_TA;
        methode2 = 'SVD_NO_TA';
        
    elseif li == 7;
        COMP = C_MC_O_TA;
        L = L_MC_O_TA;
        methode2 = 'MC_O_TA';
        
    elseif li == 8;
        COMP = C_SVD_O_TA;
        L = L_SVD_O_TA;
        methode2 = 'SVD_O_TA';
        
    end;
    
end;


function [COMP, L] = MC_NO_NT(XY, UV1, varargin);

[nbm,RIEN] = size(XY);

%---Vérification du bon nombre des variables
nbvarargin = length(varargin);
ncam = nargin - 1;

%---Modification du nom des variables dans varargin
UV1_ini = UV1;
for i = 1:nbvarargin;
    eval(['UV' num2str(i+1) ' = varargin{' num2str(i) '};']);
    eval(['UV' num2str(i+1) '_ini = varargin{' num2str(i) '};']);
end;

%Calcul des coefficients
for j = 1:ncam;
    clear X;
    clear Y;
    clear UV;
    
    %Check for the ones if there is any
    eval(['[li2, co2] = find(UV' num2str(j) ' == -1);']);
    XYec = XY;
    if isempty(co2) == 0;
        eval(['UV' num2str(j) '(:,co2(1:2:end)) = [];']);
        XYec(co2(1:2:end), :) = [];
    end;
    nbmec = length(XYec(:,1));
    
    eval(['UV = UV' num2str(j) ';']);
    X(1:2:2*nbmec,1:3) = [XYec ones(nbmec,1)];
    X(2:2:2*nbmec,4:6) = [XYec ones(nbmec,1)];
    X(1:2:2*nbmec,7:9) = -((ones(3,1)*UV(1,:)).* [XYec ones(nbmec,1)]')';
    X(2:2:2*nbmec,7:9) = -((ones(3,1)*UV(2,:)).* [XYec ones(nbmec,1)]')';
    Y = -X(:,9);
    X = X(1:2*nbmec,1:8);
    L(:,j) = ((X'*X)^(-1))*(X'*Y);
end;

%Calcul du comparateur et des résidus
for i = 1:nbm;
    clear X2;
    clear Y2;
    
    ncamEC = 0;
    for j = 1:ncam;
        eval(['UVec = UV' num2str(j) '_ini;']);
        if UVec(1,i) ~= -1;
            eval(['X2(' num2str(j*2-1) ',1:2) = [((UV' num2str(j) '_ini(1,' num2str(i) ').*L(7,' num2str(j) ')) - L(1,' num2str(j) ')) ((UV' num2str(j) '_ini(1,' num2str(i) ').*L(8,' num2str(j) ')) - L(2,' num2str(j) '))];']);
            eval(['X2(' num2str(j*2) ',1:2) = [((UV' num2str(j) '_ini(2,' num2str(i) ').*L(7,' num2str(j) ')) - L(4,' num2str(j) ')) ((UV' num2str(j) '_ini(2,' num2str(i) ').*L(8,' num2str(j) ')) - L(5,' num2str(j) '))];']);
            
            eval(['Y2(' num2str(j*2-1) ':' num2str(j*2) ',1) = [(L(3,' num2str(j) ')-UV' num2str(j) '_ini(1,' num2str(i) '));(L(6,' num2str(j) ')-UV' num2str(j) '_ini(2,' num2str(i) '))];']);
            ncamEC = ncamEC + 1;
        end;
    end;

    if ncamEC < 1;
        COMP(i,1:2) = [NaN NaN];
        
        resx(i,1) = NaN;
        resy(i,1) = NaN;
        res_xy(i,1) = NaN;
    else;
        xy = ((X2'*X2)^(-1))*(X2'*Y2);
        COMP(i,1:2) = xy';

        resx(i,1) = (XY(i,1)-COMP(i,1)).^2;
        resy(i,1) = (XY(i,2)-COMP(i,2)).^2;
        res_xy(i,1) = sqrt(resx(i,1)+resy(i,1));
    end;
end;
MatNAN = isnan(resx);
li = find(MatNAN == 1);
res_xyB = res_xy;
resxB = resx;
resyB = resy;
iter = 0;
if isempty(li) == 0;
    for i = 1:length(li);
        res_xyB(li(i)-iter,:) = [];
        resxB(li(i)-iter,:) = [];
        resyB(li(i)-iter,:) = [];
        iter = iter + 1;
    end;
    nbmB = nbm - length(li);
    res_tot = sqrt(sum(res_xyB.^2)/nbmB);
    res_x = sqrt(sum(resxB)/nbmB);
    res_y = sqrt(sum(resyB)/nbmB);
else;
    res_tot = sqrt(sum(res_xy.^2)/nbm);
    res_x = sqrt(sum(resx)/nbm);
    res_y = sqrt(sum(resy)/nbm);
end;

COMP(1:nbm,3) = res_xy;
COMP(nbm+1,1:3) = [res_x res_y res_tot];


function [COMP, L] = SVD_NO_NT(XY, UV1, varargin);

[nbm,~] = size(XY);

%---Vérification du bon nombre des variables
nbvarargin = length(varargin);
ncam = nargin - 1;

%---Modification du nom des variables dans varargin
UV1_ini = UV1;
for i = 1:nbvarargin;
    eval(['UV' num2str(i+1) ' = varargin{' num2str(i) '};']);
    eval(['UV' num2str(i+1) '_ini = varargin{' num2str(i) '};']);
end;

%Calcul des coefficients
for j = 1:ncam;
    clear X
    clear Y
    clear UV
    
    %Check for the ones if there is any
    eval(['[li2, co2] = find(UV' num2str(j) ' == -1);']);
    XYec = XY;
    if isempty(co2) == 0;
        eval(['UV' num2str(j) '(:,co2(1:2:end)) = [];']);
        XYec(co2(1:2:end), :) = [];
    end;
    nbmec = length(XYec(:,1));
    
    %Calcul des coefficients initiaux
    eval(['UV = UV' num2str(j) ';']);
    X(1:2:2*nbmec,1:3) = [XYec ones(nbmec,1)];
    X(2:2:2*nbmec,4:6) = [XYec ones(nbmec,1)];
    X(1:2:2*nbmec,7:9) = -((ones(3,1)*UV(1,:)).* [XYec ones(nbmec,1)]')';
    X(2:2:2*nbmec,7:9) = -((ones(3,1)*UV(2,:)).* [XYec ones(nbmec,1)]')';
    
    [U,S,V] = svd(X);
    hh = V(:,9);
    hh = hh/hh(9);
    L(:,j) = hh(1:8);
end;

%Calcul du comparateur et des résidus
for i = 1:nbm;
    clear X2;
    clear Y2;
    
    ncamEC = 0;
    for j = 1:ncam;
        eval(['UVec = UV' num2str(j) '_ini;']);
        if UVec(1,i) ~= -1;
            eval(['X2(' num2str(j*2-1) ',1:2) = [((UV' num2str(j) '_ini(1,' num2str(i) ').*L(7,' num2str(j) ')) - L(1,' num2str(j) ')) ((UV' num2str(j) '_ini(1,' num2str(i) ').*L(8,' num2str(j) ')) - L(2,' num2str(j) '))];']);
            eval(['X2(' num2str(j*2) ',1:2) = [((UV' num2str(j) '_ini(2,' num2str(i) ').*L(7,' num2str(j) ')) - L(4,' num2str(j) ')) ((UV' num2str(j) '_ini(2,' num2str(i) ').*L(8,' num2str(j) ')) - L(5,' num2str(j) '))];']);
            
            eval(['Y2(' num2str(j*2-1) ':' num2str(j*2) ',1) = [(L(3,' num2str(j) ')-UV' num2str(j) '_ini(1,' num2str(i) '));(L(6,' num2str(j) ')-UV' num2str(j) '_ini(2,' num2str(i) '))];']);
            ncamEC = ncamEC + 1;
        end;
    end;
    if ncamEC < 1;
        COMP(i,1:2) = [NaN NaN];
        
        resx(i,1) = NaN;
        resy(i,1) = NaN;
        res_xy(i,1) = NaN;  
    else;
        xy = ((X2'*X2)^(-1))*(X2'*Y2);
        COMP(i,1:2) = xy';

        resx(i,1) = (XY(i,1)-COMP(i,1)).^2;
        resy(i,1) = (XY(i,2)-COMP(i,2)).^2;
        res_xy(i,1) = sqrt(resx(i,1)+resy(i,1));
    end;
end;
MatNAN = isnan(resx);
li = find(MatNAN == 1);
res_xyB = res_xy;
resxB = resx;
resyB = resy;
iter = 0;
if isempty(li) == 0;
    for i = 1:length(li);
        res_xyB(li(i)-iter,:) = [];
        resxB(li(i)-iter,:) = [];
        resyB(li(i)-iter,:) = [];
        iter = iter + 1;
    end;
    nbmB = nbm - length(li);
    res_tot = sqrt(sum(res_xyB.^2)/nbmB);
    res_x = sqrt(sum(resxB)/nbmB);
    res_y = sqrt(sum(resyB)/nbmB);
else;
    res_tot = sqrt(sum(res_xy.^2)/nbm);
    res_x = sqrt(sum(resx)/nbm);
    res_y = sqrt(sum(resy)/nbm);
end;

COMP(1:nbm,3) = res_xy;
COMP(nbm+1,1:3) = [res_x res_y res_tot];


function [COMP, L] = MC_O_NT(XY, UV1, varargin);

[nbm,RIEN] = size(XY);

%---Vérification du bon nombre des variables
nbvarargin = length(varargin);
ncam = nargin - 1;

%---Modification du nom des variables dans varargin
UV1_ini = UV1;
for i = 1:nbvarargin;
    eval(['UV' num2str(i+1) ' = varargin{' num2str(i) '};']);
    eval(['UV' num2str(i+1) '_ini = varargin{' num2str(i) '};']);
end;

%Calcul des coefficients
for j = 1:ncam;
    clear X;
    clear UV;
    clear Y;
    clear m_err;
    clear m_err2;
    clear m_err3;
    
    %Check for the ones if there is any
    eval(['[li2, co2] = find(UV' num2str(j) ' == -1);']);
    XYec = XY;
    if isempty(co2) == 0;
        eval(['UV' num2str(j) '(:,co2(1:2:end)) = [];']);
        XYec(co2(1:2:end), :) = [];
    end;
    nbmec = length(XYec(:,1));
    
    eval(['UV = UV' num2str(j) ';']);
    X(1:2:2*nbmec,1:3) = [XYec ones(nbmec,1)];
    X(2:2:2*nbmec,4:6) = [XYec ones(nbmec,1)];
    X(1:2:2*nbmec,7:9) = -((ones(3,1)*UV(1,:)).* [XYec ones(nbmec,1)]')';
    X(2:2:2*nbmec,7:9) = -((ones(3,1)*UV(2,:)).* [XYec ones(nbmec,1)]')';

    Y = -X(:,9);
    X = X(1:2*nbmec,1:8);
    
    L_ini(:,j) = ((X'*X)^(-1))*(X'*Y);
    H = reshape([L_ini(:,j);1],3,3)';
    
    %Optimisation (construction de la matrice jacobienne)
    for iter = 1:10;
        L = reshape(H',9,1);
        L = L(1:8);
  
        mrep = H * [XYec ones(nbmec,1)]';
        MMM = ([XYec ones(nbmec,1)]' ./ (ones(3,1)*mrep(3,:)));

        J = zeros(2*nbmec,8);
        J(1:2:2*nbmec,1:3) = -MMM';
        J(2:2:2*nbmec,4:6) = -MMM';
        mrep = mrep ./ (ones(3,1)*mrep(3,:));

       	m_err = UV(1:2,:) - mrep(1:2,:);
        m_err = m_err(:);
        m_err2(:,iter) = sqrt((m_err(1:2:2*nbmec,1).^2+m_err(2:2:2*nbmec,1).^2)./nbmec);
        m_err3(1,iter) = mean(m_err2(:,iter));

        MMM2 = (ones(3,1)*mrep(1,:)) .* MMM;
        MMM3 = (ones(3,1)*mrep(2,:)) .* MMM;
        MMM = ([XYec ones(nbmec,1)]' ./ (ones(3,1)*mrep(3,:)))';

        J(1:2:2*nbmec,7:8) = MMM2(1:2,:)';
        J(2:2:2*nbmec,7:8) = MMM3(1:2,:)';

        L_innov  = inv(J'*J)*J'*m_err;
        L_up = L - L_innov;
        H = reshape([L_up;1],3,3)';
        L = L_up;
        L2(:,iter) = L;
    end;
    %Sélection des meilleurs paramètres pour chacune des caméras
    I2 = find(m_err3 == min(m_err3));
    if length(I2) ~= 1;
        I2 = I2(1,1);
    end;
    Lfin(:,j) = L2(1:8,I2);
end;
clear L
L = Lfin;

%Calcul du comparateur et des résidus
for i = 1:nbm;
    clear X2;
    clear Y2;

    ncamEC = 0;
    for j = 1:ncam;
        eval(['UVec = UV' num2str(j) '_ini;']);
        if UVec(1,i) ~= -1;
            eval(['X2(' num2str(j*2-1) ',1:2) = [((UV' num2str(j) '_ini(1,' num2str(i) ').*L(7,' num2str(j) ')) - L(1,' num2str(j) ')) ((UV' num2str(j) '_ini(1,' num2str(i) ').*L(8,' num2str(j) ')) - L(2,' num2str(j) '))];']);
            eval(['X2(' num2str(j*2) ',1:2) = [((UV' num2str(j) '_ini(2,' num2str(i) ').*L(7,' num2str(j) ')) - L(4,' num2str(j) ')) ((UV' num2str(j) '_ini(2,' num2str(i) ').*L(8,' num2str(j) ')) - L(5,' num2str(j) '))];']);
            
            eval(['Y2(' num2str(j*2-1) ':' num2str(j*2) ',1) = [(L(3,' num2str(j) ')-UV' num2str(j) '_ini(1,' num2str(i) '));(L(6,' num2str(j) ')-UV' num2str(j) '_ini(2,' num2str(i) '))];']);
            ncamEC = ncamEC + 1;
        end;
    end;
    if ncamEC < 1;
        COMP(i,1:2) = [NaN NaN];
        
        resx(i,1) = NaN;
        resy(i,1) = NaN;
        res_xy(i,1) = NaN;
    else;
        xy = ((X2'*X2)^(-1))*(X2'*Y2);
        COMP(i,1:2) = xy';

        resx(i,1) = (XY(i,1)-COMP(i,1)).^2;
        resy(i,1) = (XY(i,2)-COMP(i,2)).^2;
        res_xy(i,1) = sqrt(resx(i,1)+resy(i,1));
    end;
end;
MatNAN = isnan(resx);
li = find(MatNAN == 1);
res_xyB = res_xy;
resxB = resx;
resyB = resy;
iter = 0;
if isempty(li) == 0;
    for i = 1:length(li);
        res_xyB(li(i)-iter,:) = [];
        resxB(li(i)-iter,:) = [];
        resyB(li(i)-iter,:) = [];
        iter = iter + 1;
    end;
    nbmB = nbm - length(li);
    res_tot = sqrt(sum(res_xyB.^2)/nbmB);
    res_x = sqrt(sum(resxB)/nbmB);
    res_y = sqrt(sum(resyB)/nbmB);
else;
    res_tot = sqrt(sum(res_xy.^2)/nbm);
    res_x = sqrt(sum(resx)/nbm);
    res_y = sqrt(sum(resy)/nbm);
end;

COMP(1:nbm,3) = res_xy;
COMP(nbm+1,1:3) = [res_x res_y res_tot];


function [COMP, L] = SVD_O_NT(XY, UV1, varargin);

[nbm,~] = size(XY);

%---Vérification du bon nombre des variables
nbvarargin = length(varargin);
ncam = nargin - 1;

%---Modification du nom des variables dans varargin
UV1_ini = UV1;
for i = 1:nbvarargin;
    eval(['UV' num2str(i+1) ' = varargin{' num2str(i) '};']);
    eval(['UV' num2str(i+1) '_ini = varargin{' num2str(i) '};']);
end;

%Calcul des coefficients
for j = 1:ncam;
    clear X;
    clear UV;
    clear m_err;
    clear m_err2;
    clear m_err3;
    
    %Check for the ones if there is any
    eval(['[li2, co2] = find(UV' num2str(j) ' == -1);']);
    XYec = XY;
    if isempty(co2) == 0;
        eval(['UV' num2str(j) '(:,co2(1:2:end)) = [];']);
        XYec(co2(1:2:end), :) = [];
    end;
    nbmec = length(XYec(:,1));
    
    eval(['UV = UV' num2str(j) ';']);
    X(1:2:2*nbmec,1:3) = [XYec ones(nbmec,1)];
    X(2:2:2*nbmec,4:6) = [XYec ones(nbmec,1)];
    X(1:2:2*nbmec,7:9) = -((ones(3,1)*UV(1,:)).* [XYec ones(nbmec,1)]')';
    X(2:2:2*nbmec,7:9) = -((ones(3,1)*UV(2,:)).* [XYec ones(nbmec,1)]')';
    
    [U,S,V] = svd(X);
    hh = V(:,9);
    hh = hh/hh(9);
    L_ini = hh(1:8);
    H = reshape([L_ini;1],3,3)';
    
    %Optimisation (construction de la matrice jacobienne)
    for iter = 1:10;
        L = reshape(H',9,1);
        L = L(1:8);
  
        mrep = H * [XYec ones(nbmec,1)]';
        MMM = ([XYec ones(nbmec,1)]' ./ (ones(3,1)*mrep(3,:)));

        J = zeros(2*nbmec,8);
        J(1:2:2*nbmec,1:3) = -MMM';
        J(2:2:2*nbmec,4:6) = -MMM';
        mrep = mrep ./ (ones(3,1)*mrep(3,:));

       	m_err = UV(1:2,:) - mrep(1:2,:);
        m_err = m_err(:);
        m_err2(:,iter) = sqrt((m_err(1:2:2*nbmec,1).^2+m_err(2:2:2*nbmec,1).^2)./nbmec);
        m_err3(1,iter) = mean(m_err2(:,iter));

        MMM2 = (ones(3,1)*mrep(1,:)) .* MMM;
        MMM3 = (ones(3,1)*mrep(2,:)) .* MMM;
        MMM = ([XYec ones(nbmec,1)]' ./ (ones(3,1)*mrep(3,:)))';

        J(1:2:2*nbmec,7:8) = MMM2(1:2,:)';
        J(2:2:2*nbmec,7:8) = MMM3(1:2,:)';

        L_innov  = inv(J'*J)*J'*m_err;
        L_up = L - L_innov;
        H = reshape([L_up;1],3,3)';
        L = L_up;
        L2(:,iter) = L;
    end;

    %Sélection des meilleurs paramètres pour chacune des caméras
    I2 = find(m_err3 == min(m_err3));
    if length(I2) ~= 1;
        I2 = I2(1,1);
    end;
    Lfin(:,j) = L2(1:8,I2);
end;
clear L
L = Lfin;

%Calcul du comparateur et des résidus
for i = 1:nbm;
    clear X2;
    clear Y2;

    ncamEC = 0;
    for j = 1:ncam;
        eval(['UVec = UV' num2str(j) '_ini;']);
        if UVec(1,i) ~= -1;
            eval(['X2(' num2str(j*2-1) ',1:2) = [((UV' num2str(j) '_ini(1,' num2str(i) ').*L(7,' num2str(j) ')) - L(1,' num2str(j) ')) ((UV' num2str(j) '_ini(1,' num2str(i) ').*L(8,' num2str(j) ')) - L(2,' num2str(j) '))];']);
            eval(['X2(' num2str(j*2) ',1:2) = [((UV' num2str(j) '_ini(2,' num2str(i) ').*L(7,' num2str(j) ')) - L(4,' num2str(j) ')) ((UV' num2str(j) '_ini(2,' num2str(i) ').*L(8,' num2str(j) ')) - L(5,' num2str(j) '))];']);
            
            eval(['Y2(' num2str(j*2-1) ':' num2str(j*2) ',1) = [(L(3,' num2str(j) ')-UV' num2str(j) '_ini(1,' num2str(i) '));(L(6,' num2str(j) ')-UV' num2str(j) '_ini(2,' num2str(i) '))];']);
            ncamEC = ncamEC + 1;
        end;
    end;
    if ncamEC < 1;
        COMP(i,1:2) = [NaN NaN];
        
        resx(i,1) = NaN;
        resy(i,1) = NaN;
        res_xy(i,1) = NaN;
    else;
        xy = ((X2'*X2)^(-1))*(X2'*Y2);
        COMP(i,1:2) = xy';

        resx(i,1) = (XY(i,1)-COMP(i,1)).^2;
        resy(i,1) = (XY(i,2)-COMP(i,2)).^2;
        res_xy(i,1) = sqrt(resx(i,1)+resy(i,1));
    end;
end;
MatNAN = isnan(resx);
li = find(MatNAN == 1);
res_xyB = res_xy;
resxB = resx;
resyB = resy;
iter = 0;
if isempty(li) == 0;
    for i = 1:length(li);
        res_xyB(li(i)-iter,:) = [];
        resxB(li(i)-iter,:) = [];
        resyB(li(i)-iter,:) = [];
        iter = iter + 1;
    end;
    nbmB = nbm - length(li);
    res_tot = sqrt(sum(res_xyB.^2)/nbmB);
    res_x = sqrt(sum(resxB)/nbmB);
    res_y = sqrt(sum(resyB)/nbmB);
else;
    res_tot = sqrt(sum(res_xy.^2)/nbm);
    res_x = sqrt(sum(resx)/nbm);
    res_y = sqrt(sum(resy)/nbm);
end;

COMP(1:nbm,3) = res_xy;
COMP(nbm+1,1:3) = [res_x res_y res_tot];


function [COMP, L] = MC_NO_TA(XY, UV1, varargin);

[nbm,~] = size(XY);
%---Vérification du bon nombre des variables
nbvarargin = length(varargin);
ncam = nargin - 1;

%---Modification du nom des variables dans varargin
UV1_ini = UV1;
for i = 1:nbvarargin;
    eval(['UV' num2str(i+1) ' = varargin{' num2str(i) '};']);
    eval(['UV' num2str(i+1) '_ini = varargin{' num2str(i) '};']);
end;

for j = 1:ncam;
    clear X;
    clear UV;
    clear Y;
    
    %Check for the ones if there is any
    eval(['[li2, co2] = find(UV' num2str(j) ' == -1);']);
    XYec = XY;
    if isempty(co2) == 0;
        eval(['UV' num2str(j) '(:,co2(1:2:end)) = [];']);
        XYec(co2(1:2:end), :) = [];
    end;
    nbmec = length(XYec(:,1));
    
    eval(['UV = UV' num2str(j) ';']);
    
    %Transformation affine
    ax = UV(1,:);
    ay = UV(2,:);
    mxx = mean(ax);
    myy = mean(ay);
    ax = ax - mxx;
    ay = ay - myy;
    scxx = mean(abs(ax));
    scyy = mean(abs(ay));
    Hnorm = [1/scxx 0 -mxx/scxx;0 1/scyy -myy/scyy;0 0 1];
    inv_Hnorm = [scxx 0 mxx ; 0 scyy myy; 0 0 1];
    mn = Hnorm*[UV;ones(1,nbmec)];
    
    %Calcul des coefficients
    X(1:2:2*nbmec,1:3) = [XYec ones(nbmec,1)];
    X(2:2:2*nbmec,4:6) = [XYec ones(nbmec,1)];
    X(1:2:2*nbmec,7:9) = -((ones(3,1)*mn(1,:)).* [XYec ones(nbmec,1)]')';
    X(2:2:2*nbmec,7:9) = -((ones(3,1)*mn(2,:)).* [XYec ones(nbmec,1)]')';
    Y = -X(:,9);
    X = X(1:2*nbmec,1:8);
    L_prov = ((X'*X)^(-1))*(X'*Y);
    L_prov = reshape([L_prov;1],3,3)';
    L_prov = inv_Hnorm*L_prov;
    L_prov = reshape(L_prov',9,1);
    L(:,j) = L_prov(1:8);
end;

%Calcul du comparateur et des résidus
for i = 1:nbm;
    clear X2;
    clear Y2;

    ncamEC = 0;
    for j = 1:ncam;
        eval(['UVec = UV' num2str(j) '_ini;']);
        if UVec(1,i) ~= -1;
            eval(['X2(' num2str(j*2-1) ',1:2) = [((UV' num2str(j) '_ini(1,' num2str(i) ').*L(7,' num2str(j) ')) - L(1,' num2str(j) ')) ((UV' num2str(j) '_ini(1,' num2str(i) ').*L(8,' num2str(j) ')) - L(2,' num2str(j) '))];']);
            eval(['X2(' num2str(j*2) ',1:2) = [((UV' num2str(j) '_ini(2,' num2str(i) ').*L(7,' num2str(j) ')) - L(4,' num2str(j) ')) ((UV' num2str(j) '_ini(2,' num2str(i) ').*L(8,' num2str(j) ')) - L(5,' num2str(j) '))];']);

            eval(['Y2(' num2str(j*2-1) ':' num2str(j*2) ',1) = [(L(3,' num2str(j) ')-UV' num2str(j) '_ini(1,' num2str(i) '));(L(6,' num2str(j) ')-UV' num2str(j) '_ini(2,' num2str(i) '))];']);
            ncamEC = ncamEC + 1;
        end;
    end;
    if ncamEC < 1;
        COMP(i,1:2) = [NaN NaN];
        
        resx(i,1) = NaN;
        resy(i,1) = NaN;
        res_xy(i,1) = NaN;
    else;
        xy = ((X2'*X2)^(-1))*(X2'*Y2);
        COMP(i,1:2) = xy';

        resx(i,1) = (XY(i,1)-COMP(i,1)).^2;
        resy(i,1) = (XY(i,2)-COMP(i,2)).^2;
        res_xy(i,1) = sqrt(resx(i,1)+resy(i,1));
    end;
end;
MatNAN = isnan(resx);
li = find(MatNAN == 1);
res_xyB = res_xy;
resxB = resx;
resyB = resy;
iter = 0;
if isempty(li) == 0;
    for i = 1:length(li);
        res_xyB(li(i)-iter,:) = [];
        resxB(li(i)-iter,:) = [];
        resyB(li(i)-iter,:) = [];
        iter = iter + 1;
    end;
    nbmB = nbm - length(li);
    res_tot = sqrt(sum(res_xyB.^2)/nbmB);
    res_x = sqrt(sum(resxB)/nbmB);
    res_y = sqrt(sum(resyB)/nbmB);
else;
    res_tot = sqrt(sum(res_xy.^2)/nbm);
    res_x = sqrt(sum(resx)/nbm);
    res_y = sqrt(sum(resy)/nbm);
end;

COMP(1:nbm,3) = res_xy;
COMP(nbm+1,1:3) = [res_x res_y res_tot];


function [COMP, L] = SVD_NO_TA(XY, UV1, varargin);

[nbm,~] = size(XY);
%---Vérification du bon nombre des variables
nbvarargin = length(varargin);
ncam = nargin - 1;

%---Modification du nom des variables dans varargin
UV1_ini = UV1;
for i = 1:nbvarargin;
    eval(['UV' num2str(i+1) ' = varargin{' num2str(i) '};']);
    eval(['UV' num2str(i+1) '_ini = varargin{' num2str(i) '};']);
end;

for j = 1:ncam
    
    clear X;
    clear Y;
    clear UV;
    
    %Check for the ones if there is any
    eval(['[li2, co2] = find(UV' num2str(j) ' == -1);']);
    XYec = XY;
    if isempty(co2) == 0;
        eval(['UV' num2str(j) '(:,co2(1:2:end)) = [];']);
        XYec(co2(1:2:end), :) = [];
    end;
    nbmec = length(XYec(:,1));
    
    eval(['UV = UV' num2str(j) ';']);
    
    %Transformation affine
    ax = UV(1,:);
    ay = UV(2,:);
    mxx = mean(ax);
    myy = mean(ay);
    ax = ax - mxx;
    ay = ay - myy;
    scxx = mean(abs(ax));
    scyy = mean(abs(ay));
    Hnorm = [1/scxx 0 -mxx/scxx;0 1/scyy -myy/scyy;0 0 1];
    inv_Hnorm = [scxx 0 mxx ; 0 scyy myy; 0 0 1];
    mn = Hnorm*[UV;ones(1,nbmec)];
    
    %Calcul des coefficients
    X(1:2:2*nbmec,1:3) = [XYec ones(nbmec,1)];
    X(2:2:2*nbmec,4:6) = [XYec ones(nbmec,1)];
    X(1:2:2*nbmec,7:9) = -((ones(3,1)*mn(1,:)).* [XYec ones(nbmec,1)]')';
    X(2:2:2*nbmec,7:9) = -((ones(3,1)*mn(2,:)).* [XYec ones(nbmec,1)]')';
    [U,S,V] = svd(X);
    hh = V(:,9);
    hh = hh/hh(9);
    L_prov = hh(1:8);
    L_prov = reshape([L_prov;1],3,3)';
    L_prov = inv_Hnorm*L_prov;
    L_prov = reshape(L_prov',9,1);
    L(:,j) = L_prov(1:8);
end;

%Calcul du comparateur et des résidus
for i = 1:nbm;
    clear X2;
    clear Y2;

    ncamEC = 0;
    for j = 1:ncam;
        eval(['UVec = UV' num2str(j) '_ini;']);
        if UVec(1,i) ~= -1;
            eval(['X2(' num2str(j*2-1) ',1:2) = [((UV' num2str(j) '_ini(1,' num2str(i) ').*L(7,' num2str(j) ')) - L(1,' num2str(j) ')) ((UV' num2str(j) '_ini(1,' num2str(i) ').*L(8,' num2str(j) ')) - L(2,' num2str(j) '))];']);
            eval(['X2(' num2str(j*2) ',1:2) = [((UV' num2str(j) '_ini(2,' num2str(i) ').*L(7,' num2str(j) ')) - L(4,' num2str(j) ')) ((UV' num2str(j) '_ini(2,' num2str(i) ').*L(8,' num2str(j) ')) - L(5,' num2str(j) '))];']);
            
            eval(['Y2(' num2str(j*2-1) ':' num2str(j*2) ',1) = [(L(3,' num2str(j) ')-UV' num2str(j) '_ini(1,' num2str(i) '));(L(6,' num2str(j) ')-UV' num2str(j) '_ini(2,' num2str(i) '))];']);
            ncamEC = ncamEC + 1;
        end;
    end;
    if ncamEC < 1;
        COMP(i,1:2) = [NaN NaN];
        
        resx(i,1) = NaN;
        resy(i,1) = NaN;
        res_xy(i,1) = NaN;
    else;
        xy = ((X2'*X2)^(-1))*(X2'*Y2);
        COMP(i,1:2) = xy';

        resx(i,1) = (XY(i,1)-COMP(i,1)).^2;
        resy(i,1) = (XY(i,2)-COMP(i,2)).^2;
        res_xy(i,1) = sqrt(resx(i,1)+resy(i,1));
    end;
end;
MatNAN = isnan(resx);
li = find(MatNAN == 1);
res_xyB = res_xy;
resxB = resx;
resyB = resy;
iter = 0;
if isempty(li) == 0;
    for i = 1:length(li);
        res_xyB(li(i)-iter,:) = [];
        resxB(li(i)-iter,:) = [];
        resyB(li(i)-iter,:) = [];
        iter = iter + 1;
    end;
    nbmB = nbm - length(li);
    res_tot = sqrt(sum(res_xyB.^2)/nbmB);
    res_x = sqrt(sum(resxB)/nbmB);
    res_y = sqrt(sum(resyB)/nbmB);
else;
    res_tot = sqrt(sum(res_xy.^2)/nbm);
    res_x = sqrt(sum(resx)/nbm);
    res_y = sqrt(sum(resy)/nbm);
end;

COMP(1:nbm,3) = res_xy;
COMP(nbm+1,1:3) = [res_x res_y res_tot];


function [COMP, L] = MC_O_TA(XY, UV1, varargin);

[nbm,~] = size(XY);

%---Vérification du bon nombre des variables
nbvarargin = length(varargin);
ncam = nargin - 1;

%---Modification du nom des variables dans varargin
UV1_ini = UV1;
for i = 1:nbvarargin;
    eval(['UV' num2str(i+1) ' = varargin{' num2str(i) '};']);
    eval(['UV' num2str(i+1) '_ini = varargin{' num2str(i) '};']);
end;

for j = 1:ncam;
    
    clear X;
    clear Y;
    clear UV;
    clear m_err;
    clear m_err2;
    clear m_err3;
    
    %Check for the ones if there is any
    eval(['[li2, co2] = find(UV' num2str(j) ' == -1);']);
    XYec = XY;
    if isempty(co2) == 0;
        eval(['UV' num2str(j) '(:,co2(1:2:end)) = [];']);
        XYec(co2(1:2:end), :) = [];
    end;
    nbmec = length(XYec(:,1));
    
    eval(['UV = UV' num2str(j) ';']);
    
    %Transformation affine
    ax = UV(1,:);
    ay = UV(2,:);
    mxx = mean(ax);
    myy = mean(ay);
    ax = ax - mxx;
    ay = ay - myy;
    scxx = mean(abs(ax));
    scyy = mean(abs(ay));
    Hnorm = [1/scxx 0 -mxx/scxx;0 1/scyy -myy/scyy;0 0 1];
    inv_Hnorm = [scxx 0 mxx ; 0 scyy myy; 0 0 1];
    mn = Hnorm*[UV;ones(1,nbmec)];
    
    %Calcul des coefficients
    X(1:2:2*nbmec,1:3) = [XYec ones(nbmec,1)];
    X(2:2:2*nbmec,4:6) = [XYec ones(nbmec,1)];
    X(1:2:2*nbmec,7:9) = -((ones(3,1)*mn(1,:)).* [XYec ones(nbmec,1)]')';
    X(2:2:2*nbmec,7:9) = -((ones(3,1)*mn(2,:)).* [XYec ones(nbmec,1)]')';
    Y = -X(:,9);
    X = X(1:2*nbmec,1:8);
    L_prov = ((X'*X)^(-1))*(X'*Y);
    L_prov = reshape([L_prov;1],3,3)';
    L_prov = inv_Hnorm*L_prov;
    L_prov = reshape(L_prov',9,1);
    L_ini = L_prov(1:8);

    H = reshape([L_ini;1],3,3)';
    %Optimisation (construction de la matrice jacobienne)
    for iter = 1:10;
        L = reshape(H',9,1);
        L = L(1:8);
  
        mrep = H * [XYec ones(nbmec,1)]';
        MMM = ([XYec ones(nbmec,1)]' ./ (ones(3,1)*mrep(3,:)));

        J = zeros(2*nbmec,8);
        J(1:2:2*nbmec,1:3) = -MMM';
        J(2:2:2*nbmec,4:6) = -MMM';
        mrep = mrep ./ (ones(3,1)*mrep(3,:));

       	m_err = UV(1:2,:) - mrep(1:2,:);
        m_err = m_err(:);
        m_err2(:,iter) = sqrt((m_err(1:2:2*nbmec,1).^2+m_err(2:2:2*nbmec,1).^2)./nbmec);
        m_err3(1,iter) = mean(m_err2(:,iter));

        MMM2 = (ones(3,1)*mrep(1,:)) .* MMM;
        MMM3 = (ones(3,1)*mrep(2,:)) .* MMM;
        MMM = ([XYec ones(nbmec,1)]' ./ (ones(3,1)*mrep(3,:)))';

        J(1:2:2*nbmec,7:8) = MMM2(1:2,:)';
        J(2:2:2*nbmec,7:8) = MMM3(1:2,:)';

        L_innov  = inv(J'*J)*J'*m_err;
        L_up = L - L_innov;
        H = reshape([L_up;1],3,3)';
        L = L_up;
        L2(:,iter) = L;
    end;
    %Sélection des meilleurs paramètres pour chacune des caméras
    I2 = find(m_err3 == min(m_err3));
    if length(I2) ~= 1;
        I2 = I2(1,1);
    end;
    Lfin(:,j) = L2(1:8,I2);
end;
clear L
L = Lfin;

%Calcul du comparateur et des résidus
for i = 1:nbm;
    clear X2;
    clear Y2;

    ncamEC = 0;
    for j = 1:ncam;
        eval(['UVec = UV' num2str(j) '_ini;']);
        if UVec(1,i) ~= -1;
            eval(['X2(' num2str(j*2-1) ',1:2) = [((UV' num2str(j) '_ini(1,' num2str(i) ').*L(7,' num2str(j) ')) - L(1,' num2str(j) ')) ((UV' num2str(j) '_ini(1,' num2str(i) ').*L(8,' num2str(j) ')) - L(2,' num2str(j) '))];']);
            eval(['X2(' num2str(j*2) ',1:2) = [((UV' num2str(j) '_ini(2,' num2str(i) ').*L(7,' num2str(j) ')) - L(4,' num2str(j) ')) ((UV' num2str(j) '_ini(2,' num2str(i) ').*L(8,' num2str(j) ')) - L(5,' num2str(j) '))];']);

            eval(['Y2(' num2str(j*2-1) ':' num2str(j*2) ',1) = [(L(3,' num2str(j) ')-UV' num2str(j) '_ini(1,' num2str(i) '));(L(6,' num2str(j) ')-UV' num2str(j) '_ini(2,' num2str(i) '))];']);
            ncamEC = ncamEC + 1;
        end;
    end;
    if ncamEC < 1;
        COMP(i,1:2) = [NaN NaN];
        
        resx(i,1) = NaN;
        resy(i,1) = NaN;
        res_xy(i,1) = NaN;
    else;
        xy = ((X2'*X2)^(-1))*(X2'*Y2);
        COMP(i,1:2) = xy';

        resx(i,1) = (XY(i,1)-COMP(i,1)).^2;
        resy(i,1) = (XY(i,2)-COMP(i,2)).^2;
        res_xy(i,1) = sqrt(resx(i,1)+resy(i,1));
    end;
end;
MatNAN = isnan(resx);
li = find(MatNAN == 1);
res_xyB = res_xy;
resxB = resx;
resyB = resy;
iter = 0;
if isempty(li) == 0;
    for i = 1:length(li);
        res_xyB(li(i)-iter,:) = [];
        resxB(li(i)-iter,:) = [];
        resyB(li(i)-iter,:) = [];
        iter = iter + 1;
    end;
    nbmB = nbm - length(li);
    res_tot = sqrt(sum(res_xyB.^2)/nbmB);
    res_x = sqrt(sum(resxB)/nbmB);
    res_y = sqrt(sum(resyB)/nbmB);
else;
    res_tot = sqrt(sum(res_xy.^2)/nbm);
    res_x = sqrt(sum(resx)/nbm);
    res_y = sqrt(sum(resy)/nbm);
end;

COMP(1:nbm,3) = res_xy;
COMP(nbm+1,1:3) = [res_x res_y res_tot];


function [COMP, L] = SVD_O_TA(XY, UV1, varargin);

[nbm,~] = size(XY);

%---Vérification du bon nombre des variables
nbvarargin = length(varargin);
ncam = nargin - 1;

%---Modification du nom des variables dans varargin
UV1_ini = UV1;
for i = 1:nbvarargin;
    eval(['UV' num2str(i+1) ' = varargin{' num2str(i) '};']);
    eval(['UV' num2str(i+1) '_ini = varargin{' num2str(i) '};']);
end;

for j = 1:ncam;
    
    clear X;
    clear UV;
    clear m_err;
    clear m_err2;
    clear m_err3;
    
    %Check for the ones if there is any
    eval(['[li2, co2] = find(UV' num2str(j) ' == -1);']);
    XYec = XY;
    if isempty(co2) == 0;
        eval(['UV' num2str(j) '(:,co2(1:2:end)) = [];']);
        XYec(co2(1:2:end), :) = [];
    end;
    nbmec = length(XYec(:,1));
    
    eval(['UV = UV' num2str(j) ';']);
    
    %Transformation affine
    ax = UV(1,:);
    ay = UV(2,:);
    mxx = mean(ax);
    myy = mean(ay);
    ax = ax - mxx;
    ay = ay - myy;
    scxx = mean(abs(ax));
    scyy = mean(abs(ay));
    Hnorm = [1/scxx 0 -mxx/scxx;0 1/scyy -myy/scyy;0 0 1];
    inv_Hnorm = [scxx 0 mxx ; 0 scyy myy; 0 0 1];
    mn = Hnorm*[UV;ones(1,nbmec)];
    
    %Calcul des coefficients
    X(1:2:2*nbmec,1:3) = [XYec ones(nbmec,1)];
    X(2:2:2*nbmec,4:6) = [XYec ones(nbmec,1)];
    X(1:2:2*nbmec,7:9) = -((ones(3,1)*mn(1,:)).* [XYec ones(nbmec,1)]')';
    X(2:2:2*nbmec,7:9) = -((ones(3,1)*mn(2,:)).* [XYec ones(nbmec,1)]')';
    [U,S,V] = svd(X);
    hh = V(:,9);
    hh = hh/hh(9);
    L_prov = hh(1:8);
    L_prov = reshape([L_prov;1],3,3)';
    L_prov = inv_Hnorm*L_prov;
    L_prov = reshape(L_prov',9,1);
    L_ini = L_prov(1:8);

    H = reshape([L_ini;1],3,3)';
    %Optimisation (construction de la matrice jacobienne)
    for iter = 1:10;
        L = reshape(H',9,1);
        L = L(1:8);
  
        mrep = H * [XYec ones(nbmec,1)]';
        MMM = ([XYec ones(nbmec,1)]' ./ (ones(3,1)*mrep(3,:)));

        J = zeros(2*nbmec,8);
        J(1:2:2*nbmec,1:3) = -MMM';
        J(2:2:2*nbmec,4:6) = -MMM';
        mrep = mrep ./ (ones(3,1)*mrep(3,:));

       	m_err = UV(1:2,:) - mrep(1:2,:);
        m_err = m_err(:);
        m_err2(:,iter) = sqrt((m_err(1:2:2*nbmec,1).^2+m_err(2:2:2*nbmec,1).^2)./nbmec);
        m_err3(1,iter) = mean(m_err2(:,iter));

        MMM2 = (ones(3,1)*mrep(1,:)) .* MMM;
        MMM3 = (ones(3,1)*mrep(2,:)) .* MMM;
        MMM = ([XYec ones(nbmec,1)]' ./ (ones(3,1)*mrep(3,:)))';

        J(1:2:2*nbmec,7:8) = MMM2(1:2,:)';
        J(2:2:2*nbmec,7:8) = MMM3(1:2,:)';

        L_innov  = inv(J'*J)*J'*m_err;
        L_up = L - L_innov;
        H = reshape([L_up;1],3,3)';
        L = L_up;
        L2(:,iter) = L;
    end;
    
    %Sélection des meilleurs paramètres pour chacune des caméras
    I2 = find(m_err3 == min(m_err3));
    if length(I2) ~= 1;
        I2 = I2(1,1);
    end;
    Lfin(:,j) = L2(1:8,I2);
end;
L = Lfin;

%Calcul du comparateur et des résidus
for i = 1:nbm;
    clear X2;
    clear Y2;

    ncamEC = 0;
    for j = 1:ncam;
        eval(['UVec = UV' num2str(j) '_ini;']);
        if UVec(1,i) ~= -1;
            eval(['X2(' num2str(j*2-1) ',1:2) = [((UV' num2str(j) '_ini(1,' num2str(i) ').*L(7,' num2str(j) ')) - L(1,' num2str(j) ')) ((UV' num2str(j) '_ini(1,' num2str(i) ').*L(8,' num2str(j) ')) - L(2,' num2str(j) '))];']);
            eval(['X2(' num2str(j*2) ',1:2) = [((UV' num2str(j) '_ini(2,' num2str(i) ').*L(7,' num2str(j) ')) - L(4,' num2str(j) ')) ((UV' num2str(j) '_ini(2,' num2str(i) ').*L(8,' num2str(j) ')) - L(5,' num2str(j) '))];']);
            
            eval(['Y2(' num2str(j*2-1) ':' num2str(j*2) ',1) = [(L(3,' num2str(j) ')-UV' num2str(j) '_ini(1,' num2str(i) '));(L(6,' num2str(j) ')-UV' num2str(j) '_ini(2,' num2str(i) '))];']);
            ncamEC = ncamEC + 1;
        end;
    end;
    if ncamEC < 1;
        COMP(i,1:2) = [NaN NaN];
        
        resx(i,1) = NaN;
        resy(i,1) = NaN;
        res_xy(i,1) = NaN;
    else;
        xy = ((X2'*X2)^(-1))*(X2'*Y2);
        COMP(i,1:2) = xy';

        resx(i,1) = (XY(i,1)-COMP(i,1)).^2;
        resy(i,1) = (XY(i,2)-COMP(i,2)).^2;
        res_xy(i,1) = sqrt(resx(i,1)+resy(i,1));
    end;
end;
MatNAN = isnan(resx);
li = find(MatNAN == 1);
res_xyB = res_xy;
resxB = resx;
resyB = resy;
iter = 0;
if isempty(li) == 0;
    for i = 1:length(li);
        res_xyB(li(i)-iter,:) = [];
        resxB(li(i)-iter,:) = [];
        resyB(li(i)-iter,:) = [];
        iter = iter + 1;
    end;
    nbmB = nbm - length(li);
    res_tot = sqrt(sum(res_xyB.^2)/nbmB);
    res_x = sqrt(sum(resxB)/nbmB);
    res_y = sqrt(sum(resyB)/nbmB);
else;
    res_tot = sqrt(sum(res_xy.^2)/nbm);
    res_x = sqrt(sum(resx)/nbm);
    res_y = sqrt(sum(resy)/nbm);
end;

COMP(1:nbm,3) = res_xy;
COMP(nbm+1,1:3) = [res_x res_y res_tot];
