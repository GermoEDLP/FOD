program tp1_7;
 uses Crt;
 type
    str20 = string[20];
    str8 = string[8];
    novela = record
        codigo: integer;
        nombre: str20;
        genero: str20;
        precio: real;
    end;
    archivo = file of novela;

function menu():integer;
var opc: integer;
begin
    writeln('Elige una opción: ');
    writeln('==================');
    writeln('1. Importar desde .txt');
    writeln('2. Agregar Novelas');
    writeln('3. Modificar novelas');
    writeln('4. Listar todas las novelas');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

procedure importar();
var
    texto: Text;
    novelas: archivo;
    nov: novela;
begin
    assign(texto, 'data/novelas.txt');
    reset(texto);
    assign(novelas, 'data/datosEj6.dat');
    rewrite(novelas);
    while (not eof(texto)) do begin
        readln(texto, nov.codigo, nov.precio, nov.genero);
        readln(texto, nov.nombre);
        write(novelas, nov);
    end;
    writeln('Archivo importado con exito...');
    close(novelas);
    close(texto);
end;

function agregarNovela(): novela;
var 
    nov: novela;
begin
    writeln();
    writeln('Código: ');
    readln(nov.codigo);
    writeln('Nombre: ');
    readln(nov.nombre);
    writeln('Genero: ');
    readln(nov.genero);
    writeln('Precio: ');
    readln(nov.precio);
    agregarNovela:=nov;
end;

procedure agregarNovelas();
var
    novelas: archivo;
    nov: novela;
    add: char;
begin
    assign(novelas, 'data/datosEj6.dat');
    reset(novelas);
    seek(novelas, fileSize(novelas));
    writeln('Desea agregar una novela (s/n): ');
    readln(add);
    while(add='s')do begin
        nov := agregarNovela();
        write(novelas, nov);
        writeln('Desea agregar otra novela (s/n): ');
        readln(add);
    end;
    close(novelas);
end;

procedure modiifcarNovelas();
var
    novelas: archivo;
    nov: novela;
    nuevaNov: novela;
    filter: str20;
begin
    assign(novelas, 'data/datosEj6.dat');
    reset(novelas);
    writeln('Indique el código de la novela: ');
    readln(filter);
    while(not eof(novelas)) do begin
        read(novelas, nov);
        if(Pos(filter, nov.codigo)<>0) then begin                                       
            writeln('Codigo: ', nov.codigo, ' | Nombre: ', nov.nombre);
            writeln('Genero: ', nov.genero, ' | Precio: $', nov.precio:0:2);
            writeln('Indique los nuevos valores: ');
            nuevaNov:=agregarNovela();
            seek(novelas, filePos(novelas)-1);
            write(novelas, nuevaNov);
        end;
    end;
    close(novelas);
end;

procedure listar();
var
    novelas: archivo;
    nov: novela;
begin
    assign(novelas, 'data/datosEj6.dat');
    reset(novelas);
    while(not eof(novelas)) do begin
        read(novelas, nov);
        writeln();
        writeln('Codigo: ', nov.codigo, ' | Nombre: ', nov.nombre);
        writeln('Genero: ', nov.genero, ' | Precio: $', nov.precio:0:2);
    end;
    writeln();
    close(novelas);
end;

var
    fin: boolean;
    opc: integer;

begin
    fin:=false;
    repeat
        opc:=menu();
        case opc of
            1: begin
                importar();
            end;
            2: begin
                agregarNovelas();
            end;
            3: begin
                modiifcarNovelas();
            end;
            4: begin
                listar();
            end;
            0: begin
                fin:=true;
            end;

        end;


    until(fin);



end.
    