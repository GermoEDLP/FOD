program tp2_9;
	const valor_alto = 9999;
	type
		votos = record
			prov: integer;
			mesa: integer;
			loc: integer;
            votos: integer;
	  	end;
	maestro = file of votos;

procedure leer(var archivo: maestro; var dato: votos);
begin
	if (not(EOF(archivo))) then 
		read (archivo, dato)
	else 
		dato.prov:= valor_alto;
end;

procedure importar();
var
    archivo: maestro;
    reg: votos;
    texto: Text;
begin
    assign(archivo, 'dataEj9/maestro.dat');
    rewrite(archivo);
    assign(texto, 'dataEj9/maestro.txt');
    reset(texto);
    while(not eof(texto)) do begin
        //prov loc mesa votos
        readln(texto, reg.prov, reg.loc, reg.mesa, reg.votos);
        write(archivo, reg);
    end;
    close(archivo);
    close(texto);
    writeln('Archivo maestro importado correctamente!!');
    writeln();
end;

var
 	reg: votos;
 	archivo: maestro;
 	total, totLoc, totProv: integer;
 	loc, prov: integer;
begin
    importar();
    writeln('Presione ENTER para continuar.');
    readln();
    assign(archivo, 'dataEj9/maestro.dat');
    reset(archivo);
    leer(archivo, reg);
    total := 0;
    while (reg.prov <> valor_alto)do begin
        writeln();
        writeln('Provincia ', reg.prov);
        writeln('-------------');
        totProv:=0;
        prov:= reg.prov;
        while(prov=reg.prov)do begin
            totLoc:=0;
            loc:=reg.loc;
            while((prov=reg.prov) and (loc=reg.loc)) do begin
                totLoc:=totLoc+reg.votos;
                leer(archivo, reg);
            end;
            writeln();
            writeln('Localidad ', loc,':        Total: ', totLoc);
            totProv:=totProv+totLoc;
        end;
        writeln();
        writeln('Total provincia ', prov,': ', totProv);
        total:=total+totProv;
    end;
    writeln();
    writeln('Total general de votos: ', total);
end.



