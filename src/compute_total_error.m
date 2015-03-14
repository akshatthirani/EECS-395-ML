function total_error = compute_total_error(errors)
    
    total_tp = 0;
    total_tn = 0;
    total_fp = 0;
    total_fn = 0;
    
    for i=1:size(errors,2)
        total_tp = total_tp + errors(i).tp;
        total_tn = total_tn + errors(i).tn;
        total_fp = total_fp + errors(i).fp;
        total_fn = total_fn + errors(i).fn;
    end

    N = total_tp + total_tn + total_fp + total_fn;
    misclassified = (total_fp + total_fn);
    total_error.error_rate = misclassified/N;
    total_error.p_precision = total_tp/(total_tp+total_fp);
    total_error.n_precision = total_tn/(total_tn+total_fn);
    total_error.p_recall = total_tp/(total_tp+total_fn);
    total_error.n_recall = total_tn/(total_tn+total_fp);    
    
end