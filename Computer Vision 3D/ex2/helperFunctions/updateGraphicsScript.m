% Update the graphics, depending on the "method" used
switch method
    case 'edge'
        set(hImObj ,'cdata',curIm);
        set(hImObjEdge ,'cdata',edgeIm);
    case 'gradient'
        set(hImObjDx,'cdata',dx(:,:,gradInd));
        set(hImObjDy,'cdata',dy(:,:,gradInd));
        set(hImObjDt,'cdata',dt(:,:,gradInd));
        set(hImObj  ,'cdata',curIm);
    otherwise %flow methods
        set(hImObj ,'cdata',curIm);
        set(hQvObjLines ,'UData', sc*U1, 'VData', sc*V1);
        set(hQvObjPoints,'UData', sc*U2, 'VData', sc*V2);

end
