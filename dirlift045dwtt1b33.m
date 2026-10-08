function [aL,aH,hL,hH,vL,vH,dL,dH] =dirlift045dwtt1b33(A)

patchin=double(A);

 patchin=imrotate(patchin,90);

patchin=patchin';
%
 [zL,zH]=dlift1b33(patchin);

  [a,h]= lift045ah1b33(zL);
  [v,d]=lift045ah1b33(zH);
 
%    [a,h,v,d]=lift045ah1(zL,zH);
%   a=imrotate(a,-90);
%   h=imrotate(h,-90);
%   v=imrotate(v,-90);
%   d=imrotate(d,-90);
 [aL,aH]=dlift1b33(a);
  [hL,hH]=dlift1b33(h);
  
  [vL,vH]=dlift1b33(v);
  [dL,dH]=dlift1b33(d);