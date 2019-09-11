# Nonlinear-ARX-Identification

A dataset is given, measured on an unknown dynamic system with one input and one output. The order of the dynamics is not larger than three, and the dynamics may be nonlinear while the output may be affected by noise. Your task is to develop a black-box model for this system, using a polynomial, nonlinear ARX model. A second data set measured on the same system is provided for validating the developed model. The two data sets will be given in a MATLAB data file, with variables id and val containing the two sets as objects of type iddata from the System Identification toolbox. Recall that the input, output, and sampling time are available on fields u, y, Ts respectively. As a backup in case the system identification toolbox is not installed on the computer, id array and val array contain the same two datasets but now in an array format, with the structure: time values on the first column, input on the second column, and output on the last column.

Consider model orders na, nb, and delay nk, following the convention of the arx MATLAB function. Then, the nonlinear ARX model is:

(1) yˆ(k) = p(y(k − 1), . . . , y(k − na), u(k − nk), u(k − nk − 1), . . . , u(k − nk − nb + 1)) = p(d(k))

where the vector of delayed outputs and inputs is denoted by 

d(k) = [y(k − 1), . . . , y(k − na), u(k − nk), u(k − nk − 1), . . . , u(k − nk − nb + 1)]T, 

and p is a polynomial of degree m in these variables. For instance, if na = nb = nk = 1, then d = [y(k − 1), u(k − 1)]T , and if we take degree m = 2, we can write the polynomial explicitly as:

(2) y(k) = ay(k − 1) + bu(k − 1) + cy(k − 1)2 + vu(k − 1)2 + wu(k − 1)y(k − 1) + z

where a, b, c, v, w, z are real coefficients, and the parameters of the model. Note that the model is nonlinear, since it contains squares and products of delayed variables (as opposed to the ARX model which would only contain the terms linear in y(k−1) and u(k−1)). Crucially however, the model is still linear in the parameters so linear regression can still be used to identify these parameters. Note that the linear ARX form is a special case of the general form (1), obtained by taking degree m = 1, which leads to:

yˆ(k) = ay(k − 1) + bu(k − 1) + c

and further imposing that the free term c = 0 (without this condition, the model would be called affine). The requirements follow. Code a function that generates such an ARX model, for configurable model orders na, nb, delay nk, and polynomial degree m. Code also the linear regression procedure to identify the parameters, and the usage of the model on arbitrary input data. Note that the model should be usable in two modes:

• One-step-ahead prediction, which uses knowledge of the real delayed outputs of the system; in the example, we would apply (2) at step k with variables y(k − 1), u(k − 1) on the right-hand side.

• Simulation, in which knowledge about the real outputs is not available, so we can only use previous outputs of the model itself; in the example we would replace y(k −1) on the right-hand side of (2) by the previously simulated value yˆ(k − 1). Identify such a nonlinear ARX model using the identification data, and validate it on the validation data. Choose carefully the model orders and the delay, as well as the polynomial degree. To reduce the search space you may take na = nb. Report the one-step-ahead prediction error, and the simulation error for both the identification and the validation sets (use the mean squared error).
