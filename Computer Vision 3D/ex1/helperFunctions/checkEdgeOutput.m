% checks for consistency in the DoEdgeStrength output
function checkEdgeOutput(edgeIm)
      if (ndims(edgeIm) ~=2 || size(edgeIm,1) ~= size(edgeIm,2))
          error('function "DoEdgeStrength" has returned an invalid edge image. edgeIm should be square, 2D');
      end      

