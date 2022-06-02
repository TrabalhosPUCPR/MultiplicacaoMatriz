determinant([[A, B], [C, D]|_], R) :-
    R is (A*D - B*C).
determinant([[A, B, C], [D, E, F], [G, H, I]|_], R) :-
    R is (A*E*I - B*D*I) + (B*F*G - A*F*H) + (C*D*H - C*E*G). 
% multiplica e soma todas as diagonais e subtrai pela multiplicacao e subtracao das antidiagonais, funciona apenas para matrizes de ordem 2 e 3

% [A, B, C] A, B
% [D, E, F] D, E
% [G, H, I] G, H

multiplyMatrix(M1, M2, R) :- multiplyMatrix(M1, M2, R, 0, []).
    
multiplyMatrix(_, M2, R, Cont, R) :- len(M2, L), Cont > L + 1, !. % caso o contador que esta sendo usado para controlar o numero de recursoes o predicado faz ultrapasse
multiplyMatrix(M1, _, R, Cont, R) :- len(M1, L), Cont > L + 1, !. % o tamanho de qualquer uma das duas matrizes, sai da recursao e iguala o resultado final com o valor temporario
multiplyMatrix([H|M1], M2, R, Cont, Temp) :- 
    multiplyMatrixx([H|M1], M2, Temp2, [], 0), % multiplica todos os valores da linha atual por todas as colunas que a segunda matriz tem
    append(Temp, [Temp2], Temp3), % junta o resultado da multiplicacao com o valor temporario que esta acumulando os resultados passados em uma propria matriz
    Cont2 is Cont + 1, % adiciona um ao contador de recursoes que o predicado fez
    multiplyMatrix(M1, M2, R, Cont2, Temp3).

multiplyMatrixx([], _, R, R, _) :- !.
multiplyMatrixx(_, [H|_], R, R, Col) :- len(H, L), L - 1 < Col, !.
multiplyMatrixx([H|M1], M2, R, Temp, Col) :-
    getCol(M2, Col, C2), % pega a coluna Col da segunda matriz e retorna uma lista com os valores
    multiplyListXList(H, C2, Temp2), % multiplica a lista que esta no Header da primeira matriz pela coluna Col da segunda matriz 
    append(Temp, [Temp2], Temp3), % junta o resultado da multiplicacao com o valor temporario que esta acumulando em uma lista os resultados
    Col2 is Col+1, % adiciona 1 ao Col para proxima vez multiplicar a segunda coluna
    multiplyMatrixx([H|M1], M2, R, Temp3, Col2).

multiplyListXList(L1, L2, R) :- multiplyListXList(L1, L2, R, 0). % multiplica uma lista por outra lista e retorna o resultado
multiplyListXList([], [], R, R) :- !. % quando as duas listas dada como parametro forem vazias, sai da recursao e iguala o resultado final com o valor temporario
multiplyListXList([H|L1], [H2|L2], R, Temp) :-
    Temp2 is H*H2+Temp, % multiplica o header das duas listas e soma com o valor temporario que acumula todos os resultados passados
    multiplyListXList(L1, L2, R, Temp2).
    
getIndex(L, I, N) :- getIndex(L, I, N, 0). % retorna o valor que ta na posicao I
getIndex([N|_], I, N, I) :- !. % caso a posicao que estiver atualmente for I, sai da recursao e iguala o resultado final com o header da lista
getIndex([_|L], I, N, Temp) :-
    Temp2 is Temp + 1,
    getIndex(L, I, N, Temp2).

getCol(L, I, R) :- getCol(L, I, R, []). % retorna todos os valores que estao na coluna I como uma lista propria
getCol([], _, R, R) :- !. % quando a lista dada como parametro for vazia sai da recursao e iguala o resultado final com o valor temporario
getCol([H|L], I, R, Temp) :-
    getIndex(H, I, Temp2), % pega o valor que ta na coluna I
    append(Temp, [Temp2], Temp3), % junta com o valor temporario que ta guardando os valores
	getCol(L, I, R, Temp3).

len(L, R) :- len(L, R, 0). % apenas retorna o tamanho da list
len([], R, R) :- !.
len([_|L], R, Temp) :- 
    Temp2 is Temp +1,
    len(L, R, Temp2).
    
/** <examples>
?- multiplyMatrix([[1,2],[3,4],[5,6]], [[1,9,2],[3,5,4]],R).
?- multiplyMatrix([[2,4,8],[3,6,7]], [[2,1],[2,1],[4,4]],R).
?- determinant([[10,4,2],[3,6,5],[10,9,7]],R).
?- determinant([[10,4],[3,6]],R).
*/
