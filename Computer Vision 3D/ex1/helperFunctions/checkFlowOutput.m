% checks for consistency in the DoFlow output
function checkFlowOutput(U1, V1)
      if (ndims(U1) ~=2 || ndims(V1) ~=2)
          error('function "DoFlow" has returned invalid output. "U1", "V1" must all be 2D');end      
      if (size(U1,1) ~= size(U1,2))
          error('function "DoFlow" has returned an invalid output. "U1", "V1" must all be square (height=width)');end
      if (sum(size(U1) ~= size(V1)))
          error('function "DoFlow" has returned an invalid output. "U1", "V1" must all be of equal size');end
      
