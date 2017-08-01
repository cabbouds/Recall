mi_log_trans <- function(){
  trans_new(name = 'mi_log', transform = function(x) (sign(x)*log(abs(x)+1)), 
            inverse = function(y) (sign(y)*( exp(abs(y))-1)))
}
