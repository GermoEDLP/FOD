program tp3_7;
uses Crt, sysutils;
type
   str30 = string[30];
   str8 = string[8];
   ave = record
       cod: integer;
       nombre: str30;
       familia: str30;
       desc: str30;
       zona: str30;
   end;
   archivo = file of ave;

function menu():integer;
var opc: integer;
begin
    writeln('Elige una opción: ');
    writeln('==================');
    writeln('1. Importar archivo');
    writeln('2. Visualizar lista de aves');
    writeln('3. Eliminar aves');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

procedure importar();
var
    lista: archivo;
    a: ave;
    texto: Text;
begin
    assign(lista, 'data/ej7/aves.dat');
    assign(texto, 'data/ej7/aves.txt');
    reset(texto);
    rewrite(lista);
    while(not eof(texto))do begin
        readln(texto, a.cod, a.nombre);
        readln(texto, a.familia);
        readln(texto, a.desc);
        readln(texto, a.zona);
        write(lista, a);
    end;
    close(texto);
    close(lista);
    ClrScr;
    writeln('Importación correcta...');
end;

procedure listar();
var
    lista: archivo;
    a: ave;
begin
    assign(lista, 'data/ej7/aves.dat');
    reset(lista);
    while(not eof(lista))do begin
        read(lista, a);
        writeln('Cod.',a.cod,' -', a.nombre);
        writeln('==================');
        writeln('Familia: ', a.familia);
        writeln('Descripción: ', a.desc);
        writeln('Zona: ', a.zona);
        writeln();
    end;
    close(lista);
    writeln('<ENTER>...');
    readln();
    ClrScr;
end;

procedure comprimir();
var
    lista: archivo;
    a, ultima: ave;
    position: integer;
begin
    assign(lista, 'data/ej7/aves.dat');
    reset(lista);
    while(not eof(lista)) do begin
        read(lista, a);
        if(pos('*', a.nombre)<>0)then begin
            if(filePos(lista)=fileSize(lista))then begin
                seek(lista, filePos(lista)-1);
                Truncate(lista);
            end
            else begin
                position:=filePos(lista)-1;
                seek(lista, fileSize(lista)-1);
                read(lista, ultima);
                seek(lista, filePos(lista)-1);
                Truncate(lista);
                seek(lista, position);
                write(lista, ultima);
            end;
        end;
    end;
end;

procedure borrar();
var
    lista: archivo;
    a: ave;
    cod: integer;
    fin:boolean;
begin
    assign(lista, 'data/ej7/aves.dat');
    reset(lista);
    writeln('Ingrese el codigo del ave a eliminar (5000 termina): ');
    readln(cod);
    while(cod<>5000) do begin
        fin:=false;
        while((not eof(lista)) and (not fin)) do begin
            read(lista, a);
            if(a.cod=cod)then begin
                writeln('Ave ',a.nombre,' eliminada...');
                a.nombre:= '*'+a.nombre;
                seek(lista, filePos(lista)-1);
                write(lista, a);
                fin:=true;
            end;
        end;
        writeln('Ingrese el codigo del ave a eliminar (500000 termina): ');
        readln(cod);
    end;
    comprimir();
    close(lista);
    ClrScr;
end;

var
    fin: boolean;
    opcion: integer;
begin
    fin:=false;
    ClrScr;
    repeat
        opcion:= menu();
        case opcion of
            1: begin
                ClrScr;
            importar();
            end;
            2: begin
                ClrScr;
            listar();
            end;
            3: begin
                ClrScr;
            borrar();
            end;
            0: fin:= true;
        end;
    until (fin);       
end.





// cod nombre
// familia
// desc
// zona
