% Ben Bay
% CS 330

digit(1).
digit(2).
digit(3).
digit(4).
digit(5).
digit(6).
digit(7).
digit(8).
digit(9).

numBetween(Num, Lower, Upper) :-
	Num >= Lower,
	Num =< Upper.

% cubeBounds: (RowLow, RowHigh, ColLow, ColHigh, CubeNumber)
cubeBounds(0, 2, 0, 2, 0).
cubeBounds(0, 2, 3, 5, 1).
cubeBounds(0, 2, 6, 8, 2).
cubeBounds(3, 5, 0, 2, 3).
cubeBounds(3, 5, 3, 5, 4).
cubeBounds(3, 5, 6, 8, 5).
cubeBounds(6, 8, 0, 2, 6).
cubeBounds(6, 8, 3, 5, 7).
cubeBounds(6, 8, 6, 8, 8).

% Given a board and the index of a column of interest (0-indexed),
% returns the contents of the column as a list.
% columnAsList: (Board, ColumnNumber, AsRow)
columnAsList([], _, []).
columnAsList([Head|Tail], ColumnNum, [Item|Rest]) :-
	nth0(ColumnNum, Head, Item),
	columnAsList(Tail, ColumnNum, Rest).

% given which row and column we are in, gets which cube
% is relevant.  A helper ultimately for `getCube`.
% cubeNum: (RowNum, ColNum, WhichCube)
cubeNum(RowNum, ColNum, WhichCube) :-
	cubeBounds(RowLow, RowHigh, ColLow, ColHigh, WhichCube),
	numBetween(RowNum, RowLow, RowHigh),
	numBetween(ColNum, ColLow, ColHigh).

% Drops the first N elements from a list.  A helper ultimately
% for `getCube`.
% drop: (InputList, NumToDrop, ResultList)
drop([], _, []):-!.
drop(List, 0, List):-!.
drop([_|Tail], Num, Rest) :-
	Num > 0,
	NewNum is Num - 1,
	drop(Tail, NewNum, Rest).

% Takes the first N elements from a list.  A helper ultimately
% for `getCube`.
% take: (InputList, NumToTake, ResultList)
take([], _, []):-!.
take(_, 0, []):-!.
take([Head|Tail], Num, [Head|Rest]) :-
	Num > 0,
	NewNum is Num - 1,
	take(Tail, NewNum, Rest).

% Gets a sublist of a list in the same order, inclusive.
% A helper for `getCube`.
% sublist: (List, Start, End, NewList)
sublist(List, Start, End, NewList) :-
	drop(List, Start, TempList),
	NewEnd is End - Start + 1,
	take(TempList, NewEnd, NewList).

% Given a board and cube number, gets the corresponding cube as a list.
% Cubes are 3x3 portions, numbered from the top left to the bottom right,
% starting from 0.  For example, they would be numbered like so:
%
% 0  1  2
% 3  4  5
% 6  7  8
%
% getCube: (Board, CubeNumber, ContentsOfCube)
getCube(Board, Number, AsList) :-
	cubeBounds(RowLow, RowHigh, ColLow, ColHigh, Number),
	sublist(Board, RowLow, RowHigh, [Row1, Row2, Row3]),
	sublist(Row1, ColLow, ColHigh, Row1Nums),
	sublist(Row2, ColLow, ColHigh, Row2Nums),
	sublist(Row3, ColLow, ColHigh, Row3Nums),
	append(Row1Nums, Row2Nums, TempRow),
	append(TempRow, Row3Nums, AsList).

% import the is_set/1 function
:- use_module(library(lists)).

% helper function to split list into 9 variables.
split([H | T], H, T).
splitRows(Board, A, B, C, D, E, F, G, H, I) :-
	split(Board, A, Arest),
	split(Arest, B, Brest),
	split(Brest, C, Crest),
	split(Crest, D, Drest),
	split(Drest, E, Erest),
	split(Erest, F, Frest),
	split(Frest, G, Grest),
	split(Grest, H, Hrest),
	split(Hrest, I, []).

solve(Board) :-
	% All 9 cubes.
	getCube(Board, 0, Cube0),
	getCube(Board, 1, Cube1),
	getCube(Board, 2, Cube2),
	getCube(Board, 3, Cube3),
	getCube(Board, 4, Cube4),
	getCube(Board, 5, Cube5),
	getCube(Board, 6, Cube6),
	getCube(Board, 7, Cube7),
	getCube(Board, 8, Cube8),

	% All 9 columns.
	columnAsList(Board, 0, Col0),
	columnAsList(Board, 1, Col1),
	columnAsList(Board, 2, Col2),
	columnAsList(Board, 3, Col3),
	columnAsList(Board, 4, Col4),
	columnAsList(Board, 5, Col5),
	columnAsList(Board, 6, Col6),
	columnAsList(Board, 7, Col7),
	columnAsList(Board, 8, Col8),

	% All 9 rows.
	splitRows(Board, Row0, Row1, Row2, Row3, Row4, Row5, Row6, Row7, Row8),

	% All 81 squares.
	splitRows(Row0, Square00, Square01, Square02, Square03, Square04, Square05, Square06, Square07, Square08),
	splitRows(Row1, Square10, Square11, Square12, Square13, Square14, Square15, Square16, Square17, Square18),
	splitRows(Row2, Square20, Square21, Square22, Square23, Square24, Square25, Square26, Square27, Square28),
	splitRows(Row3, Square30, Square31, Square32, Square33, Square34, Square35, Square36, Square37, Square38),
	splitRows(Row4, Square40, Square41, Square42, Square43, Square44, Square45, Square46, Square47, Square48),
	splitRows(Row5, Square50, Square51, Square52, Square53, Square54, Square55, Square56, Square57, Square58),
	splitRows(Row6, Square60, Square61, Square62, Square63, Square64, Square65, Square66, Square67, Square68),
	splitRows(Row7, Square70, Square71, Square72, Square73, Square74, Square75, Square76, Square77, Square78),
	splitRows(Row8, Square80, Square81, Square82, Square83, Square84, Square85, Square86, Square87, Square88),
	(nonvar(Square00); var(Square00), digit(Square00), is_set(Row0), is_set(Col0), is_set(Cube0)),
	(nonvar(Square01); var(Square01), digit(Square01), is_set(Row0), is_set(Col1), is_set(Cube0)),
	(nonvar(Square02); var(Square02), digit(Square02), is_set(Row0), is_set(Col2), is_set(Cube0)),
	(nonvar(Square03); var(Square03), digit(Square03), is_set(Row0), is_set(Col3), is_set(Cube1)),
	(nonvar(Square04); var(Square04), digit(Square04), is_set(Row0), is_set(Col4), is_set(Cube1)),
	(nonvar(Square05); var(Square05), digit(Square05), is_set(Row0), is_set(Col5), is_set(Cube1)),
	(nonvar(Square06); var(Square06), digit(Square06), is_set(Row0), is_set(Col6), is_set(Cube2)),
	(nonvar(Square07); var(Square07), digit(Square07), is_set(Row0), is_set(Col7), is_set(Cube2)),
	(nonvar(Square08); var(Square08), digit(Square08), is_set(Row0), is_set(Col8), is_set(Cube2)),
	(nonvar(Square10); var(Square10), digit(Square10), is_set(Row1), is_set(Col0), is_set(Cube0)),
	(nonvar(Square11); var(Square11), digit(Square11), is_set(Row1), is_set(Col1), is_set(Cube0)),
	(nonvar(Square12); var(Square12), digit(Square12), is_set(Row1), is_set(Col2), is_set(Cube0)),
	(nonvar(Square13); var(Square13), digit(Square13), is_set(Row1), is_set(Col3), is_set(Cube1)),
	(nonvar(Square14); var(Square14), digit(Square14), is_set(Row1), is_set(Col4), is_set(Cube1)),
	(nonvar(Square15); var(Square15), digit(Square15), is_set(Row1), is_set(Col5), is_set(Cube1)),
	(nonvar(Square16); var(Square16), digit(Square16), is_set(Row1), is_set(Col6), is_set(Cube2)),
	(nonvar(Square17); var(Square17), digit(Square17), is_set(Row1), is_set(Col7), is_set(Cube2)),
	(nonvar(Square18); var(Square18), digit(Square18), is_set(Row1), is_set(Col8), is_set(Cube2)),
	(nonvar(Square20); var(Square20), digit(Square20), is_set(Row2), is_set(Col0), is_set(Cube0)),
	(nonvar(Square21); var(Square21), digit(Square21), is_set(Row2), is_set(Col1), is_set(Cube0)),
	(nonvar(Square22); var(Square22), digit(Square22), is_set(Row2), is_set(Col2), is_set(Cube0)),
	(nonvar(Square23); var(Square23), digit(Square23), is_set(Row2), is_set(Col3), is_set(Cube1)),
	(nonvar(Square24); var(Square24), digit(Square24), is_set(Row2), is_set(Col4), is_set(Cube1)),
	(nonvar(Square25); var(Square25), digit(Square25), is_set(Row2), is_set(Col5), is_set(Cube1)),
	(nonvar(Square26); var(Square26), digit(Square26), is_set(Row2), is_set(Col6), is_set(Cube2)),
	(nonvar(Square27); var(Square27), digit(Square27), is_set(Row2), is_set(Col7), is_set(Cube2)),
	(nonvar(Square28); var(Square28), digit(Square28), is_set(Row2), is_set(Col8), is_set(Cube2)),
	(nonvar(Square30); var(Square30), digit(Square30), is_set(Row3), is_set(Col0), is_set(Cube3)),
	(nonvar(Square31); var(Square31), digit(Square31), is_set(Row3), is_set(Col1), is_set(Cube3)),
	(nonvar(Square32); var(Square32), digit(Square32), is_set(Row3), is_set(Col2), is_set(Cube3)),
	(nonvar(Square33); var(Square33), digit(Square33), is_set(Row3), is_set(Col3), is_set(Cube4)),
	(nonvar(Square34); var(Square34), digit(Square34), is_set(Row3), is_set(Col4), is_set(Cube4)),
	(nonvar(Square35); var(Square35), digit(Square35), is_set(Row3), is_set(Col5), is_set(Cube4)),
	(nonvar(Square36); var(Square36), digit(Square36), is_set(Row3), is_set(Col6), is_set(Cube5)),
	(nonvar(Square37); var(Square37), digit(Square37), is_set(Row3), is_set(Col7), is_set(Cube5)),
	(nonvar(Square38); var(Square38), digit(Square38), is_set(Row3), is_set(Col8), is_set(Cube5)),
	(nonvar(Square40); var(Square40), digit(Square40), is_set(Row4), is_set(Col0), is_set(Cube3)),
	(nonvar(Square41); var(Square41), digit(Square41), is_set(Row4), is_set(Col1), is_set(Cube3)),
	(nonvar(Square42); var(Square42), digit(Square42), is_set(Row4), is_set(Col2), is_set(Cube3)),
	(nonvar(Square43); var(Square43), digit(Square43), is_set(Row4), is_set(Col3), is_set(Cube4)),
	(nonvar(Square44); var(Square44), digit(Square44), is_set(Row4), is_set(Col4), is_set(Cube4)),
	(nonvar(Square45); var(Square45), digit(Square45), is_set(Row4), is_set(Col5), is_set(Cube4)),
	(nonvar(Square46); var(Square46), digit(Square46), is_set(Row4), is_set(Col6), is_set(Cube5)),
	(nonvar(Square47); var(Square47), digit(Square47), is_set(Row4), is_set(Col7), is_set(Cube5)),
	(nonvar(Square48); var(Square48), digit(Square48), is_set(Row4), is_set(Col8), is_set(Cube5)),
	(nonvar(Square50); var(Square50), digit(Square50), is_set(Row5), is_set(Col0), is_set(Cube3)),
	(nonvar(Square51); var(Square51), digit(Square51), is_set(Row5), is_set(Col1), is_set(Cube3)),
	(nonvar(Square52); var(Square52), digit(Square52), is_set(Row5), is_set(Col2), is_set(Cube3)),
	(nonvar(Square53); var(Square53), digit(Square53), is_set(Row5), is_set(Col3), is_set(Cube4)),
	(nonvar(Square54); var(Square54), digit(Square54), is_set(Row5), is_set(Col4), is_set(Cube4)),
	(nonvar(Square55); var(Square55), digit(Square55), is_set(Row5), is_set(Col5), is_set(Cube4)),
	(nonvar(Square56); var(Square56), digit(Square56), is_set(Row5), is_set(Col6), is_set(Cube5)),
	(nonvar(Square57); var(Square57), digit(Square57), is_set(Row5), is_set(Col7), is_set(Cube5)),
	(nonvar(Square58); var(Square58), digit(Square58), is_set(Row5), is_set(Col8), is_set(Cube5)),
	(nonvar(Square60); var(Square60), digit(Square60), is_set(Row6), is_set(Col0), is_set(Cube6)),
	(nonvar(Square61); var(Square61), digit(Square61), is_set(Row6), is_set(Col1), is_set(Cube6)),
	(nonvar(Square62); var(Square62), digit(Square62), is_set(Row6), is_set(Col2), is_set(Cube6)),
	(nonvar(Square63); var(Square63), digit(Square63), is_set(Row6), is_set(Col3), is_set(Cube7)),
	(nonvar(Square64); var(Square64), digit(Square64), is_set(Row6), is_set(Col4), is_set(Cube7)),
	(nonvar(Square65); var(Square65), digit(Square65), is_set(Row6), is_set(Col5), is_set(Cube7)),
	(nonvar(Square66); var(Square66), digit(Square66), is_set(Row6), is_set(Col6), is_set(Cube8)),
	(nonvar(Square67); var(Square67), digit(Square67), is_set(Row6), is_set(Col7), is_set(Cube8)),
	(nonvar(Square68); var(Square68), digit(Square68), is_set(Row6), is_set(Col8), is_set(Cube8)),
	(nonvar(Square70); var(Square70), digit(Square70), is_set(Row7), is_set(Col0), is_set(Cube6)),
	(nonvar(Square71); var(Square71), digit(Square71), is_set(Row7), is_set(Col1), is_set(Cube6)),
	(nonvar(Square72); var(Square72), digit(Square72), is_set(Row7), is_set(Col2), is_set(Cube6)),
	(nonvar(Square73); var(Square73), digit(Square73), is_set(Row7), is_set(Col3), is_set(Cube7)),
	(nonvar(Square74); var(Square74), digit(Square74), is_set(Row7), is_set(Col4), is_set(Cube7)),
	(nonvar(Square75); var(Square75), digit(Square75), is_set(Row7), is_set(Col5), is_set(Cube7)),
	(nonvar(Square76); var(Square76), digit(Square76), is_set(Row7), is_set(Col6), is_set(Cube8)),
	(nonvar(Square77); var(Square77), digit(Square77), is_set(Row7), is_set(Col7), is_set(Cube8)),
	(nonvar(Square78); var(Square78), digit(Square78), is_set(Row7), is_set(Col8), is_set(Cube8)),
	(nonvar(Square80); var(Square80), digit(Square80), is_set(Row8), is_set(Col0), is_set(Cube6)),
	(nonvar(Square81); var(Square81), digit(Square81), is_set(Row8), is_set(Col1), is_set(Cube6)),
	(nonvar(Square82); var(Square82), digit(Square82), is_set(Row8), is_set(Col2), is_set(Cube6)),
	(nonvar(Square83); var(Square83), digit(Square83), is_set(Row8), is_set(Col3), is_set(Cube7)),
	(nonvar(Square84); var(Square84), digit(Square84), is_set(Row8), is_set(Col4), is_set(Cube7)),
	(nonvar(Square85); var(Square85), digit(Square85), is_set(Row8), is_set(Col5), is_set(Cube7)),
	(nonvar(Square86); var(Square86), digit(Square86), is_set(Row8), is_set(Col6), is_set(Cube8)),
	(nonvar(Square87); var(Square87), digit(Square87), is_set(Row8), is_set(Col7), is_set(Cube8)),
	(nonvar(Square88); var(Square88), digit(Square88), is_set(Row8), is_set(Col8), is_set(Cube8)).

% Prints out the given board.
printBoard([]).
printBoard([Head|Tail]) :-
	write(Head), nl,
	printBoard(Tail).

test1(Board) :-
	Board = [[2, _, _, _, 8, 7, _, 5, _],
		[_, _, _, _, 3, 4, 9, _, 2],
		[_, _, 5, _, _, _, _, _, 8],
		[_, 6, 4, 2, 1, _, _, 7, _],
		[7, _, 2, _, 6, _, 1, _, 9],
		[_, 8, _, _, 7, 3, 2, 4, _],
		[8, _, _, _, _, _, 4, _, _],
		[3, _, 9, 7, 4, _, _, _, _],
		[_, 1, _, 8, 2, _, _, _, 5]],
	solve(Board),
	printBoard(Board).

test2(Board) :-
	Board = [[_, _, _, 7, 9, _, 8, _, _],
		[_, _, _, _, _, 4, 3, _, 7],
		[_, _, _, 3, _, _, _, 2, 9],
		[7, _, _, _, 2, _, _, _, _],
		[5, 1, _, _, _, _, _, 4, 8],
		[_, _, _, _, 5, _, _, _, 1],
		[1, 2, _, _, _, 8, _, _, _],
		[6, _, 4, 1, _, _, _, _, _],
		[_, _, 3, _, 6, 2, _, _, _]],
	solve(Board),
	printBoard(Board).

test3(Board) :-
	Board = [[8, _, 7, _, _, _, _, _, _],
		[9, _, 3, 1, _, _, _, _, _],
		[_, 2, _, _, _, 5, _, _, _],
		[5, 6, _, _, 1, _, 3, _, _],
		[_, 3, _, _, 4, _, _, 8, _],
		[_, _, 4, _, 8, _, _, 1, 2],
		[_, _, _, 9, _, _, _, 2, _],
		[_, _, _, _, _, 2, 6, _, 5],
		[_, _, _, _, _, _, 7, _, 8]],
	solve(Board),
	printBoard(Board).
