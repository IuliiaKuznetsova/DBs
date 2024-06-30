create table TicTacToe (
    step_id serial primary key,
    field char(9) not null,
    next_step char(1) not null default 'X',
    is_game_over boolean not null default false,
    winner char(1)
);


create or replace function NewGame() 
	returns void 
	language plpgsql
	as $$
	begin
		delete from TicTacToe; -- Обнуление таблицы, так как игра начинается заново. На данный момент принято решение не хранить ходов прошлых игр. Но можно не удалять и сохранять все ходы, тогда эту строку нужно закомментировать.  
    	insert into TicTacToe (field, next_step, is_game_over) values ('_________', 'X', FALSE);
	end;
$$;


create or replace function CheckWinner(field char(9), player char(1)) 
	returns boolean 
	language plpgsql
	as $$
	begin
    return (
        (substring(field from 1 for 1) = player and substring(field from 2 for 1) = player and substring(field from 3 for 1) = player) or
        (substring(field from 4 for 1) = player and substring(field from 5 for 1) = player and substring(field from 6 for 1) = player) or
        (substring(field from 7 for 1) = player and substring(field from 8 for 1) = player and substring(field from 9 for 1) = player) or
        (substring(field from 1 for 1) = player and substring(field from 4 for 1) = player and substring(field from 7 for 1) = player) or
        (substring(field from 2 for 1) = player and substring(field from 5 for 1) = player and substring(field from 8 for 1) = player) or
        (substring(field from 3 for 1) = player and substring(field from 6 for 1) = player and substring(field from 9 for 1) = player) or
        (substring(field from 1 for 1) = player and substring(field from 5 for 1) = player and substring(field from 9 for 1) = player) or
        (substring(field from 3 for 1) = player and substring(field from 5 for 1) = player and substring(field from 7 for 1) = player)
    	);
	end;
$$;


create or replace function NextMove(X int, Y int, Val char default null) 
	returns text 
	language plpgsql
	as $$
	declare
    	current_field char(9);
    	current_step char(1);
    	is_game_over boolean;
    	step_position int;
    	winner char(1);
	begin
    -- Состояние поля на данный момент
    select tab.field, tab.next_step, tab.is_game_over, tab.winner into current_field, current_step, is_game_over, winner from  TicTacToe as tab order by step_id desc limit 1;

    -- Если игра окончена, то выводим исключение
    if is_game_over then
        raise exception 'Игра окончена. Выиграл %', winner;
		delete from TicTacToe; -- Если нужно сохранять историю ходов прошлых игр, тогда эту строку нужно закомментировать
    end if;

    -- Определяем место в массиве поля
    step_position := (Y - 1) * 3 + X;

    -- Если Val не передан, то по умолчанию берем текущего игрока
    if Val is null then 
        Val := current_step;
    end if;

    -- Записываем новый ход в массив. Если на этом месте уже стоит символ, то выводим ошибку
    if substring(current_field from  step_position for 1) = '_' then
        current_field := overlay(current_field placing Val from step_position for 1);
    else
        raise exception 'Занято. Поищи другой ход!';
    end if;

    -- Проверяем на чью-либо победу (или ничью)
    if CheckWinner(current_field, Val) then
        insert into TicTacToe (field, next_step, is_game_over, winner) values (current_field, current_step, true, Val);
        return Val || ' выиграл!';
    elsif strpos(current_field, '_') = 0 then
        insert into TicTacToe (field, next_step, is_game_over, winner) values (current_field, current_step, true, null);
        return 'Ничья! Сыграйте еще!';
    else
        -- Меняем игрока
        current_step := case current_step when 'X' then 'O' else 'X' end;
        insert into TicTacToe (field, next_step, is_game_over) values (current_field, current_step, false);
        return current_field;
    end if;
	end;
$$;

/*
----------------------------------------------------------------------
ТЕСТИРУЕМ ИГРУ
----------------------------------------------------------------------
*/ 

select * from TicTacToe; -- Вывод таблицы ходов, сделанных на данный момент за игру

-- Пример 1 (выиграл Х)
select NewGame();
select NextMove(1, 1); -- X(1, 1)
select NextMove(2, 2); -- O(2, 2)
select NextMove(1, 2); -- X(1, 2)
select NextMove(2, 1); -- O(2, 1)
select NextMove(1, 3); -- X(1, 3)

-- Пример 2 (выиграл О)
select NewGame();
select NextMove(2, 2); -- X(2, 2)
select NextMove(2, 3); -- O(2, 3)
select NextMove(3, 1); -- X(3, 1)
select NextMove(1, 3); -- O(1, 3)
select NextMove(3, 2); -- X(3, 2)
select NextMove(3, 3); -- O(3, 3)

-- Пример 3 (ничья)
select NewGame();
select NextMove(1, 2); -- X(1, 2)
select NextMove(2, 2); -- O(2, 2)
select NextMove(1, 3); -- X(1, 3)
select NextMove(1, 1); -- O(1, 1)
select NextMove(3, 3); -- X(3, 3)
select NextMove(2, 3); -- O(2, 3)
select NextMove(2, 1); -- X(2, 1)
select NextMove(3, 1); -- O(3, 1)
-- select NextMove(3, 1); -- Х(3, 1)  техническая строчка, чтобы проверить работу исключения
select NextMove(3, 2); -- X(3, 2)