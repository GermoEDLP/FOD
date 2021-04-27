program tp3_4_y_5;
uses Crt, sysutils;
type
   str50 = string[50];
   str8 = string[8];
   tTitulo = str50;
   tArchivoRevistas = file of tTitulo;

function menu():integer;
var opc: integer;
begin
    writeln('Elige una opción: ');
    writeln('==================');
    writeln('1. Ingresar información desde cero');
    writeln('2. Ingresar información de una nueva revista');
    writeln('3. Ingresar información desde archivo');
    writeln('4. Eliminar novela');
    writeln('5. Listar en pantalla');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

procedure crearRevistas();
var 
    revistas: tArchivoRevistas; 
    titulo: tTitulo; 
    texto: Text;
begin
    assign(revistas, 'data/ej4/revistas.dat');
    rewrite(revistas);
    assign(texto, 'data/ej4/revistas.txt');
    reset(texto);
    titulo:='*0';
    write(revistas, titulo);
    while(not eof(texto)) do begin
        readln(texto, titulo);
        write(revistas, titulo);
    end;
    close(texto);
    close(revistas);
    ClrScr;
    writeln('Revistas cargadas correctamente...')
end;

procedure ingresarRevistas(tipo: str8);
var
    revistas: tArchivoRevistas; 
    titulo, cabecera: tTitulo;
    position, position_cab: integer;
begin
    assign(revistas, 'data/ej4/revistas.dat');
    case tipo of
        'new': begin
            rewrite(revistas);
            titulo := '*0';
            write(revistas, titulo);
            writeln('Ingrese el titulo de la revista ("fin" termina): ');
            readln(titulo);
            while (titulo <> 'fin') do begin
                write(revistas, titulo);
                writeln();
            writeln('Ingrese el titulo de la revista ("fin" termina): ');
                readln(titulo);
            end;
            close(revistas);
        end;
        'add': begin
            reset(revistas);
            read(revistas, cabecera);
            writeln('Ingrese el titulo de la pelicula a incorporar ("fin" termina): ');
            readln(titulo);
            while (titulo <> 'fin') do begin
            position_cab:=StrToInt(copy(cabecera,2,length(cabecera)));
                if(position_cab<>0)then begin
                    position:=position_cab;
                    seek(revistas, position);
                    read(revistas, cabecera);
                    seek(revistas, position);
                    write(revistas, titulo);
                    reset(revistas);
                    write(revistas, cabecera);
                end
                else begin
                    seek(revistas, fileSize(revistas));
                    write(revistas, titulo);
                end;
                writeln();
                writeln('Ingrese el titulo de la pelicula a incorporar ("fin" termina): ');
                readln(titulo);
            end;
            close(revistas);
        end;
    end;
    ClrScr;
end;

procedure borrarRevista();
var
    revistas: tArchivoRevistas;
    titulo, cabecera: tTitulo;
    opc: str8;
    position: integer;
    fin: boolean;
begin
    assign(revistas, 'data/ej4/revistas.dat');
    reset(revistas);
    fin:=false;
    Read(revistas, cabecera);
    while((not eof(revistas)) and (not fin)) do begin
        Read(revistas, titulo);
        if(pos('*', titulo)=0)then begin
            writeln('Revista: ', titulo);
            writeln('Desea borrar esta revista (s/n)("fin" para salir): ');
            readln(opc);
            if(opc='fin') then fin:=true;
            if(opc='s') then begin
                position:= filePos(revistas)-1;
                seek(revistas, position);
                write(revistas, cabecera);
                reset(revistas);
                cabecera := '*'+IntToStr(position);
                write(revistas, cabecera);
                seek(revistas, position);
            end;
        end;
    end;
    close(revistas);
end;

procedure listarRevistas();
var 
    revistas: tArchivoRevistas;
    titulo: tTitulo;
begin
    ClrScr;
    assign(revistas, 'data/ej4/revistas.dat');
    if(FileExists('data/ej4/revistas.dat')) then begin
        reset(revistas);
        if (eof(revistas)) then begin 
            writeln('No hay revistas en la BD.');
    end;
    end
    else begin
        rewrite(revistas);
        writeln('No hay peliculas en la BD.');
    end;
    
    while (not eof(revistas)) do begin
        Read(revistas, titulo);
        if(pos('*', titulo)=0)then
            writeln(titulo);
    end;
    close(revistas);
    readln();
    ClrScr; 
end;

var
    fin: boolean;
    opcion: integer;
begin
    fin:=false;
    repeat
        opcion:= menu();
        case opcion of
            1: begin
                ClrScr;
            ingresarRevistas('new');
            end;
            2: begin
                ClrScr;
            ingresarRevistas('add');
                
            end;
            3: begin
                ClrScr;
            crearRevistas();
                
            end;
            4: begin
                ClrScr;
                borrarRevista();
            end;
            5: begin
                ClrScr;
                listarRevistas();
            end;
            0: fin:= true;
        end;
    until (fin);       
end.
