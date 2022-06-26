% this script set up some artificial data to be used in demo1
% run this one first, then demo1_learn, then demo1_classify

clear all;

% number of states
Q = 10;
% observed alphabet spaces, 
% V(k) is domain of kth observed element(feature)
num_ = 1;
for TTT = 1000:1000:10000
V = 2 * ones(1,TTT);

% number of phases, set to 1 if using HMM
M = 5;

% number of independent "features" in each observation
K = length(V);

% generate some observation sequences
N = 1;     % number of idd observation sequences
T = 100;   % length of each sequence

NULL = -1; % used in the null trick

for n=1:N
	mobsq{n} = zeros(K+1,T);
	for k=1:K
		clear uniDist;
		uniDist = (1/(V(k)+1))*ones(1,V(k)+1);
		for t=1:T            
            % construct random sequence for feature k
            tmp = sample_discrete(uniDist);
            if (tmp <= V(k))
                mobsq{n}(k,t) = tmp;
            else
                % testing the null trick
                mobsq{n}(k,t) = NULL;
            end
		end
    end
    uniDist = (1/(Q+1)) * ones(1,Q+1);
    for t=1:T
        
        % construct random state sequence
        tmp=sample_discrete(uniDist);
        if tmp <= Q 
            mobsq{n}(K+1,t)=tmp;
        else
            mobsq{n}(K+1,t)= NULL;
        end
    end
end

%%Learn
[PI,A,P,D,B,loglik] = em_cxhsmm(Q,M,K,V,mobsq,5,1e-30,'observe_state');

%%
%%classify
obsq = mobsq{1}; % pick one sequence

% must do this first
[H lnH] = compute_obprob(B,obsq,'scale');

% there are two methods for infering the hidden states
% below is a simple argmax P(x_t | obs) for each t

[rankedState probs] = smstate_decode(PI,A,P,D,H);
smoothedLabels=rankedState(1,:);

% 
% Here is the viterbi decode which returns
% the most likely sequence, rather than a sequence
% of most likely states as above
%
% argmax P(x_{1:T} | obs)
%
% If you're not sure which method to use,
% then try the viterbi first

[lvtbsq lprob] = viterbi_cxhsmm(PI,A,P,D,H,'uselog');
viterbiLabels = lvtbsq(1,:);
fprintf('Look at smoothedLabels and viterbiLabels for results.\n');








tmp_(num_) = sum(smoothedLabels == viterbiLabels)/length(viterbiLabels)


num_ = num_ + 1;
end



xx = 1:length(tmp_);
plot(xx, tmp_)



