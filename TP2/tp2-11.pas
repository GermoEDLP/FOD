program tp2_11;
 uses Crt, sysutils;
	const valor_alto = 'ZZZ';
	type
		str20 = string[20];
        str4 = string[4];
		alfa = record
			prov: str20;
			personas: integer;
            encuestados: integer;
	  	end;
        censo = record
            prov: str20;
            loc: integer;
            personas: integer;
            encuestados: integer;
        end;
	maestro = file of alfa;
	detalle = file of censo;

procedure leer(var archivo: detalle; var dato: censo);
begin
	if (not(EOF(archivo))) then 
		read (archivo, dato)
	else 
        // El primer valor por el que se ordena
		dato.prov := valor_alto;
end;

procedure importarMaestro();
var
    archivo: maestro;
    reg: alfa;
    texto: Text;
begin
    assign(archivo, 'dataEj11/maestro.dat');
    rewrite(archivo);
    assign(texto, 'dataEj11/maestro.txt');
    reset(texto);
    while(not eof(texto)) do begin
        //personas encuestados prov 
        readln(texto, reg.personas, reg.encuestados, reg.prov);
        write(archivo, reg);
    end;
    close(archivo);
    close(texto);
    writeln('Archivo maestro importado correctamente!!');
    writeln();
end;

procedure importarDetalle(num: str4);
var
    archivo: detalle;
    reg: censo;
    texto: Text;
begin
    assign(archivo, 'dataEj11/censo'+num+'.dat');
    rewrite(archivo);
    assign(texto, 'dataEj11/censo'+num+'.txt');
    reset(texto);
    while(not eof(texto)) do begin
        //personas encuestados loc prov 
        readln(texto, reg.personas, reg.encuestados, reg.loc, reg.prov);
        write(archivo, reg);
    end;
    close(archivo);
    close(texto);
    writeln('Archivo Censo '+num+' importado correctamente!!');
    writeln();
end;

procedure actualizarMaestro(num: str4);
var
    det: detalle;
    regd: censo;
    mae: maestro;
    regm: alfa;
    prov: str20;
    totProv_e, totProv_p: integer;
begin
    assign(det, 'dataEj11/censo'+num+'.dat');
    reset(det);
    assign(mae, 'dataEj11/maestro.dat');
    reset(mae);
    leer(det, regd);
    read(mae, regm);
    while (regd.prov <> valor_alto)do begin
        prov:=regd.prov;
        totProv_e:=0;
        totProv_p:=0;
        while(prov=regd.prov)do begin
            totProv_e:=totProv_e+regd.encuestados;
            totProv_p:=totProv_p+regd.personas;
            leer(det, regd);
        end;
        while(regm.prov<>prov) do 
            read(mae, regm);
        regm.encuestados:=regm.encuestados+totProv_e;
        regm.personas:=regm.personas+totProv_p;
        seek(mae, filepos(mae)-1);
        write(mae, regm);
        if(not eof(mae)) then
            read(mae, regm);
    end;
    close(mae);
    close(det);
    writeln('Archivo maestro actualizado en base a Censo '+num+'!!');
    writeln();
end;

procedure exportarMaestro();
var
    mae: maestro;
    reg: alfa;
    texto: Text;
begin
    assign(mae, 'dataEj11/maestro.dat');
    reset(mae);
    assign(texto, 'dataEj11/reporte.txt');
    rewrite(texto);
    writeln(texto, 'Reporte de productos');
    writeln(texto, '--------------------');
    writeln(texto, ' ');
    while(not eof(mae)) do begin
        read(mae, reg);
        writeln(texto, 'Provincia: ', reg.prov, ' | Encuestados:', reg.encuestados, ' | Alfabetizados: ', reg.personas);
        writeln(texto, ' ');
    end;
    close(mae);
    close(texto);
    writeln('Archivo maestro.dat exportado en reporte.txt correctamente!!');
    writeln(); 
end;


var
    i: integer;
begin
    importarMaestro();
    writeln('Presione ENTER para importar los detalles.');
    readln();
    for i:=1 to 2 do
        importarDetalle(IntToStr(i));
    writeln('Presione ENTER para actualizar el maestro.');
    readln();
    
    for i:=1 to 2 do
        actualizarMaestro(IntToStr(i));
    writeln('Presione ENTER para exportar el maestro.');
    readln();

    exportarMaestro();

end.