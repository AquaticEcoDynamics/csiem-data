function [metdata,outname] = bom_sites(nSiteID,met)

%[snum,sstr] = xlsread('BOM_Extracted.csv','A2:D10000');
warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
TableVar = readtable('BOM_Extracted.csv');
warning('ON', 'MATLAB:table:ModifiedAndSavedVarnames')

    code = TableVar{:,1};
    name = TableVar{:,2};
    latlist = TableVar{:,3};
    lonlist = TableVar{:,4};
    % code = snum(:,1);
    % name = sstr(:,1);
    % lat = snum(:,3);
    % lon = snum(:,4);

name = regexprep(name,'\s','_');
name = regexprep(name,'(','');
name = regexprep(name,')','');

sss = find(code == nSiteID);

if ~isempty(sss)
        disp(name{sss(1)});

    metdata.(name{sss(1)}) = met;
    metdata.(name{sss(1)}).lat = latlist(sss(1));
    metdata.(name{sss(1)}).lon = lonlist(sss(1));
    
    
    outname = name{sss(1)};
    
else
    
    switch nSiteID
        case 9127
            metdata.mosman_park = met;
            metdata.mosman_park.lat = -32.0200;
            metdata.mosman_park.lon = 115.7692;
            
            outname = 'mosman_park';
            
        case 9192
            metdata.fremantle = met;
            metdata.fremantle.lat = -32.0533;
            metdata.fremantle.lon = 115.7647;
            
                        outname = 'fremantle';

        case 9215
            metdata.swanbourne = met;
            metdata.swanbourne.lat = -31.9558;
            metdata.swanbourne.lon = 115.7619;
            
                        outname = 'swanbourne';

        case 9977
            metdata.mandurah_new = met;
            metdata.mandurah_new.lat = -32.5219;
            metdata.mandurah_new.lon = 115.7119;
            
                        outname = 'mandurah_new';

        case 9887
            metdata.mandurah_old = met;
            metdata.mandurah_old.lat = -32.5219;
            metdata.mandurah_old.lon = 115.7119;
            
                        outname = 'mandurah_old';

        case 9538
            metdata.dwellingup = met;
            metdata.dwellingup.lat = -32.7103;
            metdata.dwellingup.lon = 116.0594;
            
                        outname = 'dwellingup';

        case 9596
            metdata.pinjarra = met;
            metdata.pinjarra.lat = -32.6272;
            metdata.pinjarra.lon = 115.8747;
            
                        outname = 'pinjarra';

        case 9039
            metdata.serpentine = met;
            metdata.serpentine.lat = -32.3536;
            metdata.serpentine.lon = 116.0050;
            
                        outname = 'serpentine';

        case 9115
            metdata.serpentine_dam = met;
            metdata.serpentine_dam.lat = -32.4022;
            metdata.serpentine_dam.lon = 116.1039;
            
                        outname = 'serpentine_dam';

        case 9877
            metdata.ludlow = met;
            metdata.ludlow.lat = -33.6033;
            metdata.ludlow.lon = 115.4983;
            
                        outname = 'ludlow';

        case 9515
            metdata.busselton_shire = met;
            metdata.busselton_shire.lat = -33.6611;
            metdata.busselton_shire.lon = 115.3456;
            
                        outname = 'busselton_shire';

        case 9569
            metdata.busselton_shire_old = met;
            metdata.busselton_shire_old.lat = -33.6611;
            metdata.busselton_shire_old.lon = 115.3456;
            
                        outname = 'busselton_shire_old';

        case 9937
            metdata.busselton_jetty = met;
            metdata.busselton_jetty.lat = -33.6294;
            metdata.busselton_jetty.lon = 115.3383;
            
                        outname = 'busselton_jetty';

        case 9603
            metdata.busselton_aero = met;
            metdata.busselton_aero.lat = -33.6858;
            metdata.busselton_aero.lon = 115.4008;
            
                        outname = 'busselton_aero';

        case 9021
            metdata.airport = met;
            metdata.airport.lat = -31.9275;
            metdata.airport.lon = 115.9764;
            
                        outname = 'airport';

        case 9225
            metdata.metro = met;
            metdata.metro.lat = -31.9192;
            metdata.metro.lon = 115.8728;
            
                        outname = 'metro';

        case 9172
            metdata.jandakot = met;
            metdata.jandakot.lat = -32.1011;
            metdata.jandakot.lon = 115.8794;
            
                        outname = 'jandakot';

        case 9127
            metdata.mosman_park = met;
            metdata.mosman_park.lat = -32.0200;
            metdata.mosman_park.lon = 115.7692;
            
                        outname = 'mosman_park';

        case 9192
            metdata.fremantle = met;
            metdata.fremantle.lat = -32.0533;
            metdata.fremantle.lon = 115.7647;
            
                        outname = 'fremantle';

        case 9215
            metdata.swanbourne = met;
            metdata.swanbourne.lat = -31.9558;
            metdata.swanbourne.lon = 115.7619;
            
                        outname = 'swanbourne';

        case 9977
            metdata.mandurah_new = met;
            metdata.mandurah_new.lat = -32.5219;
            metdata.mandurah_new.lon = 115.7119;
            
                        outname = 'mandurah_new';

        case 9887
            metdata.mandurah_old = met;
            metdata.mandurah_old.lat = -32.5219;
            metdata.mandurah_old.lon = 115.7119;
            
                        outname = 'mandurah_old';

        case 9538
            metdata.dwellingup = met;
            metdata.dwellingup.lat = -32.7103;
            metdata.dwellingup.lon = 116.0594;
            
                        outname = 'dwellingup';

        case 9596
            metdata.pinjarra = met;
            metdata.pinjarra.lat = -32.6272;
            metdata.pinjarra.lon = 115.8747;
            
                        outname = 'pinjarra';

        case 9039
            metdata.serpentine = met;
            metdata.serpentine.lat = -32.3536;
            metdata.serpentine.lon = 116.0050;
            
                        outname = 'serpentine';

        case 9115
            metdata.serpentine_dam = met;
            metdata.serpentine_dam.lat = -32.4022;
            metdata.serpentine_dam.lon = 116.1039;
            
                        outname = 'serpentine_dam';

        case 9877
            metdata.ludlow = met;
            metdata.ludlow.lat = -33.6033;
            metdata.ludlow.lon = 115.4983;
            
                        outname = 'ludlow';

        case 9515
            metdata.busselton_shire = met;
            metdata.busselton_shire.lat = -33.6611;
            metdata.busselton_shire.lon = 115.3456;
            
                        outname = 'busselton_shire';

        case 9569
            metdata.busselton_shire_old = met;
            metdata.busselton_shire_old.lat = -33.6611;
            metdata.busselton_shire_old.lon = 115.3456;
            
                        outname = 'busselton_shire_old';

        case 9937
            metdata.busselton_jetty = met;
            metdata.busselton_jetty.lat = -33.6294;
            metdata.busselton_jetty.lon = 115.3383;
            
                        outname = 'busselton_jetty';

        case 9603
            metdata.busselton_aero = met;
            metdata.busselton_aero.lat = -33.6858;
            metdata.busselton_aero.lon = 115.4008;
            
                        outname = 'busselton_aero';

        case 9021
            metdata.airport = met;
            metdata.airport.lat = -31.9275;
            metdata.airport.lon = 115.9764;
            
                        outname = 'airport';

        case 9225
            metdata.metro = met;
            metdata.metro.lat = -31.9192;
            metdata.metro.lon = 115.8728;
            
                        outname = 'metro';

        case 9172
            metdata.jandakot = met;
            metdata.jandakot.lat = -32.1011;
            metdata.jandakot.lon = 115.8794;
            
                        outname = 'jandakot';

        case 9746
            metdata.WITCHCLIFFE = met;
            metdata.WITCHCLIFFE.lat = -34.0281;
            metdata.WITCHCLIFFE.lon = 115.1042;
                        outname = 'WITCHCLIFFE';

            
        case 9091
            metdata.INNER_DOLPHIN_PYLON = met;
            metdata.INNER_DOLPHIN_PYLON.lat = -31.9889;
            metdata.INNER_DOLPHIN_PYLON.lon = 115.8311;
            
                        outname = 'INNER_DOLPHIN_PYLON';

            
        case 96033
            metdata.LIAWENEE = met;
            metdata.LIAWENEE.lat = -41.8997;
            metdata.LIAWENEE.lon = 146.6694;
            
                        outname = 'LIAWENEE';

            
        case 81124
            metdata.YARRAWONGA = met;
            metdata.YARRAWONGA.lat = -36.0294;
            metdata.YARRAWONGA.lon = 146.0306;
            
                        outname = 'YARRAWONGA';

            
        case 49136
            metdata.EUABALONG = met;
            metdata.EUABALONG.lat = -32.8261;
            metdata.EUABALONG.lon = 145.8800;
            
                        outname = 'EUABALONG';

            
        case 50137
            metdata.CONDOBOLIN_AIRPORT = met;
            metdata.CONDOBOLIN_AIRPORT.lat = -33.0682;
            metdata.CONDOBOLIN_AIRPORT.lon = 147.2133;
            
                        outname = 'CONDOBOLIN_AIRPORT';

            
        case 41097
            metdata.INGLEWOOD_FOREST = met;
            metdata.INGLEWOOD_FOREST.lat = -28.3661;
            metdata.INGLEWOOD_FOREST.lon = 150.9539;
            
                        outname = 'INGLEWOOD_FOREST';

            
        case 52057
            metdata.WEEMELAH = met;
            metdata.WEEMELAH.lat = -29.2403;
            metdata.WEEMELAH.lon = 149.1265;
            
                        outname = 'WEEMELAH';

        case 52020
            metdata.MUNGINDI_PO = met;
            metdata.MUNGINDI_PO.lat = -28.9786;
            metdata.MUNGINDI_PO.lon = 148.9899;
            
                        outname = 'MUNGINDI_PO';

        case 43109
            metdata.St_George_AP = met;
            metdata.St_George_AP.lat = -28.0489;
            metdata.St_George_AP.lon = 148.5942;
            
                        outname = 'St_George_AP';

        case 043034
            metdata.St_George_PO = met;
            metdata.St_George_PO.lat = -28.0361;
            metdata.St_George_PO.lon = 148.5814;
            
                        outname = 'St_George_PO';

        case 14015
            metdata.Darwin_AP = met;
            metdata.Darwin_AP.lat = -12.4239;
            metdata.Darwin_AP.lon = 130.8925;
            
                        outname = 'Darwin_AP';

        case 14982
            metdata.Kangaroo_Flats = met;
            metdata.Kangaroo_Flats.lat = -12.7934;
            metdata.Kangaroo_Flats.lon = 130.8542;
            
                        outname = 'Kangaroo_Flats';

        case 14314
            metdata.NOONAMAH_Airstrip = met;
            metdata.NOONAMAH_Airstrip.lat = -12.6099;
            metdata.NOONAMAH_Airstrip.lon = 131.0474;
            
                        outname = 'NOONAMAH_Airstrip';

        case 002064
            metdata.ARGYLE_AERODROME = met;
            metdata.ARGYLE_AERODROME.lat = -16.6380;
            metdata.ARGYLE_AERODROME.lon = 128.4516;
            
                        outname = 'ARGYLE_AERODROME';

        case 002056
            metdata.KUNUNURRA_AERO = met;
            metdata.KUNUNURRA_AERO.lat = -15.7814;
            metdata.KUNUNURRA_AERO.lon = 128.7100;
            
                        outname = 'KUNUNURRA_AERO';

        case  001006
            metdata.WYNDHAM_AERO = met;
            metdata.WYNDHAM_AERO.lat = -15.5100;
            metdata.WYNDHAM_AERO.lon = 128.1503;
            
                        outname = 'WYNDHAM_AERO';

        case  002012
            metdata.HALLS_CREEK_METEOROLOGICAL_OFFICE = met;
            metdata.HALLS_CREEK_METEOROLOGICAL_OFFICE.lat = -18.2291;
            metdata.HALLS_CREEK_METEOROLOGICAL_OFFICE.lon = 127.6636;
            
                        outname = 'HALLS_CREEK_METEOROLOGICAL_OFFICE';

        case 014981
            metdata.BRADSHAW_KOOLENDONG_VALLEY = met;
            metdata.BRADSHAW_KOOLENDONG_VALLEY.lat = -15.1853;
            metdata.BRADSHAW_KOOLENDONG_VALLEY.lon = 130.1169;
            
                        outname = 'BRADSHAW_KOOLENDONG_VALLEY';

        case 014850
            metdata.TIMBER_CREEK = met;
            metdata.TIMBER_CREEK.lat =-15.6614;
            metdata.TIMBER_CREEK.lon = 130.4808;
            
                        outname = 'TIMBER_CREEK';

        case 014808
            metdata.BRADSHAW_ANGALLARI_VALLEY = met;
            metdata.BRADSHAW_ANGALLARI_VALLEY.lat = -15.4397;
            metdata.BRADSHAW_ANGALLARI_VALLEY.lon = 130.5731;
            
                        outname = 'BRADSHAW_ANGALLARI_VALLEY';

        case 001036
            metdata.DOONGAN_ASA = met;
            metdata.DOONGAN_ASA.lat = -15.3792;
            metdata.DOONGAN_ASA.lon = 126.3108;
            
                        outname = 'DOONGAN_ASA';

            
        case 014825
            metdata.VICTORIA_RIVER_DOWNS = met;
            metdata.VICTORIA_RIVER_DOWNS.lat = -16.4030;
            metdata.VICTORIA_RIVER_DOWNS.lon = 131.0145;
            
                        outname = 'VICTORIA_RIVER_DOWNS';

        case 014948
            metdata.PORT_KEATS_AIRPORT = met;
            metdata.PORT_KEATS_AIRPORT.lat = -14.2494;
            metdata.PORT_KEATS_AIRPORT.lon = 129.5282;
            
                        outname = 'PORT_KEATS_AIRPORT';

        case 014829
            metdata.LAJAMANU_AIRPORT = met;
            metdata.LAJAMANU_AIRPORT.lat = -18.3324;
            metdata.LAJAMANU_AIRPORT.lon = 130.6361;
            
                        outname = 'LAJAMANU_AIRPORT';

        case 001019
            metdata.KALUMBURU = met;
            metdata.KALUMBURU.lat = -14.2964;
            metdata.KALUMBURU.lon = 126.6453;
            
                        outname = 'KALUMBURU';

        case 003093
            metdata.FITZROY_CROSSING_AERO = met;
            metdata.FITZROY_CROSSING_AERO.lat = -18.1814;
            metdata.FITZROY_CROSSING_AERO.lon = 125.5619;
            
                        outname = 'FITZROY_CROSSING_AERO';

        case 001020
            metdata.TRUSCOTT = met;
            metdata.TRUSCOTT.lat = -14.0900;
            metdata.TRUSCOTT.lon = 126.3867;
            
                        outname = 'TRUSCOTT';

        case 014949
            metdata.DELAMERE_WEAPONS_RANGE = met;
            metdata.DELAMERE_WEAPONS_RANGE.lat = -15.7441;
            metdata.DELAMERE_WEAPONS_RANGE.lon =131.9181;
        case 013045
            metdata.BALGO_HILLS_ASA = met;
            metdata.BALGO_HILLS_ASA.lat = -20.1350;
            metdata.BALGO_HILLS_ASA.lon =127.9892;
        case  001007
            metdata.TROUGHTON_ISLAND = met;
            metdata.TROUGHTON_ISLAND.lat = -13.7542;
            metdata.TROUGHTON_ISLAND.lon = 126.1485;
        case  015666
            metdata.RABBIT_FLAT = met;
            metdata.RABBIT_FLAT.lat = -20.1823;
            metdata.RABBIT_FLAT.lon = 130.0148;
        case  014901
            metdata.DOUGLAS_RIVER_RESEARCH_FARM = met;
            metdata.DOUGLAS_RIVER_RESEARCH_FARM.lat = -13.8345;
            metdata.DOUGLAS_RIVER_RESEARCH_FARM.lon = 131.1872;
        case  003108
            metdata.YAMPI_SOUND = met;
            metdata.YAMPI_SOUND.lat = -16.7671;
            metdata.YAMPI_SOUND.lon = 123.9810;
        case  014932
            metdata.TINDAL_RAAF = met;
            metdata.TINDAL_RAAF.lat = -14.5229;
            metdata.TINDAL_RAAF.lon = 132.3826;
        case  014272
            metdata.BATCHELOR_AIRPORT = met;
            metdata.BATCHELOR_AIRPORT.lat = -13.0544;
            metdata.BATCHELOR_AIRPORT.lon = 131.0252;
        case  014277
            metdata.DUM_IN_MIRRIE_AIRSTRIP = met;
            metdata.DUM_IN_MIRRIE_AIRSTRIP.lat = -12.6350;
            metdata.DUM_IN_MIRRIE_AIRSTRIP.lon =130.3725;
        case  014982
            metdata.KANGAROO_FLATS = met;
            metdata.KANGAROO_FLATS.lat = -12.7934;
            metdata.KANGAROO_FLATS.lon = 130.8542;
        case  003080
            metdata.CURTIN_AERO = met;
            metdata.CURTIN_AERO.lat = -17.5768;
            metdata.CURTIN_AERO.lon = 123.8297;
            
        otherwise
            disp('StationID not found');
            
            stop
    end
    
end