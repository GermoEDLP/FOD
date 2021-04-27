 program tp3_3;
 uses Crt, sysutils;
 type
    str20 = string[20];
    str8 = string[8];
    pelicula = record
        nombre: str20;
        genero: str20;
        duracion: integer;
        director: str20;
        precio: real;
        cod: integer;
    end;
    archivo = file of pelicula;

function menu():integer;
var opc: integer;
begin
    writeln('Elige una opción: ');
    writeln('==================');
    writeln('1. Ingresar información desde cero');
    writeln('2. Ingresar información de una nueva pelicula');
    writeln('3. Ingresar información desde archivo');
    writeln('4. Modificar novela');
    writeln('5. Eliminar novela');
    writeln('6. Listar en pantalla');
    writeln('7. Listar en archivo');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

procedure crearPeliculas();
var 
    peliculas: archivo; 
    peli: pelicula; 
    texto: Text;
begin
    assign(peliculas, 'data/ej3/peliculas.dat');
    rewrite(peliculas);
    assign(texto, 'data/ej3/peliculas.txt');
    reset(texto);
    peli.cod := 0;
    write(peliculas, peli);
    // cod nombre
    // precio genero
    // duracion director
    while(not eof(texto)) do begin
        readln(texto, peli.cod, peli.nombre);
        readln(texto, peli.precio, peli.genero);
        readln(texto, peli.duracion, peli.director);
        write(peliculas, peli);
    end;
    close(texto);
    close(peliculas);
    ClrScr;
    writeln('Peliculas cargadas correctamente...')
end;

procedure ingresarPelicula(var peli: pelicula; tipo: str8);
begin
        writeln('Ingrese el nombre de la pelicula #', peli.cod);
        if(tipo='update') then writeln('Anterior: ', peli.nombre);
        readln(peli.nombre);
        writeln('Ingrese el director de la pelicula #', peli.cod);
        if(tipo='update') then writeln('Anterior: ', peli.director);
        readln(peli.director);
        writeln('Ingrese el genero de la pelicula #', peli.cod);
        if(tipo='update') then writeln('Anterior: ', peli.genero);
        readln(peli.genero);
        writeln('Ingrese la duración en minutos de la pelicula #', peli.cod);
        if(tipo='update') then writeln('Anterior: ', peli.duracion);
        readln(peli.duracion);
        writeln('Ingrese el precio (en millones) de la pelicula #', peli.cod);
        if(tipo='update') then writeln('Anterior: ', peli.precio:0:2);
        readln(peli.precio);
end;

procedure ingresarPeliculas(tipo: str8);
var
    peliculas: archivo; 
    peli: pelicula;
    cabecera: pelicula;
    pos: integer;
begin
    assign(peliculas, 'data/ej3/peliculas.dat');
    case tipo of
        'new': begin
            rewrite(peliculas);
            peli.cod := 0;
            write(peliculas, peli);
            writeln('Ingrese el codigo de la pelicula ("0" termina): ');
            readln(peli.cod);
            while (peli.cod <> 0) do begin
                ingresarPelicula(peli, 'new');
                write(peliculas, peli);
                writeln();
                writeln('Ingrese el codigo de la pelicula ("0" termina): ');
                readln(peli.cod);
            end;
            close(peliculas);
        end;
        'add': begin
            reset(peliculas);
            read(peliculas, cabecera);
            writeln('Ingrese el codigo de la pelicula ("0" termina): ');
            readln(peli.cod);
            while (peli.cod <> 0) do begin
                ingresarPelicula(peli, 'new');
                if(cabecera.cod<0)then begin
                    pos:=0-cabecera.cod;
                    seek(peliculas, pos);
                    read(peliculas, cabecera);
                    seek(peliculas, pos);
                    write(peliculas, peli);
                    reset(peliculas);
                    write(peliculas, cabecera);
                end
                else begin
                    seek(peliculas, fileSize(peliculas));
                    write(peliculas, peli);
                end;
                writeln();
                writeln('Ingrese el codigo de la pelicula ("0" termina): ');
                readln(peli.cod);
            end;
            close(peliculas);
        end;
    end;
    ClrScr;
end;

procedure imprimirPelicula(peli: pelicula);
begin
    writeln('Pelicula #', peli.cod, ': ');
    writeln('===============');
    writeln('Nombre: '+peli.nombre);
    writeln('Director: ', peli.director);
    writeln('Dureación: ',peli.duracion,'min.');
    writeln('Genero: ',peli.genero);
    writeln('Precio: u$s',peli.precio:0:2,' millones');
    writeln();
end;

procedure listarPeliculas();
var 
    peliculas: archivo;
    peli: pelicula;
begin
    ClrScr;
    assign(peliculas, 'data/ej3/peliculas.dat');
    if(FileExists('data/ej3/peliculas.dat')) then begin
        reset(peliculas);
        if (eof(peliculas)) then begin 
            writeln('No hay peliculas en la BD.');
    end;
    end
    else begin
        rewrite(peliculas);
        writeln('No hay peliculas en la BD.');
    end;
    
    while (not eof(peliculas)) do begin
        Read(peliculas, peli);
        if(peli.cod>0) then
            imprimirPelicula(peli);
    end;
    close(peliculas);
    readln();
    ClrScr; 
end;

procedure exportarPeliculas();
var
    peliculas: archivo;
    peli: pelicula;
    texto: Text;
begin
    assign(peliculas, 'data/ej3/peliculas.dat');
    reset(peliculas);
    assign(texto, 'data/ej3/peliculasExport.txt');
    rewrite(texto);
    while(not eof(peliculas))do begin
        Read(peliculas, peli);
        if(peli.cod>0)then begin
            writeln(texto, peli.cod,' ', peli.nombre);
            writeln(texto, peli.precio:0:2,' ', peli.genero);
            writeln(texto, peli.duracion,' ',  peli.director);
        end;
    end;
    close(texto);
    close(peliculas);
    writeln('Peliculas exportadas con exito');
end;

procedure modificarPelicula();
var
    peliculas: archivo;
    peli: pelicula;
    opc: str8;
    cod: integer;
begin
    assign(peliculas, 'data/ej3/peliculas.dat');
    reset(peliculas);
    writeln('Introduzca el codigo de la pelicula a modificar: ');
    readln(cod);
    while(not eof(peliculas)) do begin
        Read(peliculas, peli);
        if(peli.cod=cod)then begin
            imprimirPelicula(peli);
            writeln();
            writeln('Desea modificar esta pelicula (s/n): ');
            readln(opc);
            if(opc='s') then begin
                ingresarPelicula(peli, 'update');
                seek(peliculas, filePos(peliculas)-1);
                write(peliculas, peli);
            end;
        end;
    end;
    close(peliculas);
end;

procedure borrarPelicula();
var
    peliculas: archivo;
    peli: pelicula;
    cabecera: pelicula;
    opc: str8;
    cod, pos: integer;
begin
    assign(peliculas, 'data/ej3/peliculas.dat');
    reset(peliculas);
    writeln('Introduzca el codigo de la pelicula a borrar: ');
    readln(cod);
    read(peliculas, cabecera);
    while(not eof(peliculas)) do begin
        read(peliculas, peli);
        if(peli.cod=cod)then begin
            imprimirPelicula(peli);
            writeln();
            writeln('Desea borrar esta pelicula (s/n): ');
            readln(opc);
            if(opc='s') then begin
                pos:= filePos(peliculas)-1;
                seek(peliculas, pos);
                write(peliculas, cabecera);
                reset(peliculas);
                cabecera.cod := 0-pos;
                write(peliculas, cabecera);
            end; 
        end;
    end;
    close(peliculas);
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
            ingresarPeliculas('new');
            end;
            2: begin
                ClrScr;
            ingresarPeliculas('add');
                
            end;
            3: begin
                ClrScr;
            crearPeliculas();
                
            end;
            4: begin
                ClrScr;
                modificarPelicula();
            end;
            5: begin
                ClrScr;
                borrarPelicula();
            end;
            6: begin
                ClrScr;
                listarPeliculas();
            end;
            7: begin
                ClrScr;
                exportarPeliculas();
            end;
            0: fin:= true;
        end;
    until (fin);       
end.
