%% 1) Import para fMRI data

% INPUTS: 
% directories
%
% OUTPUTS:
% data (matlab table of data)
% pcnsDataTable

function [pcnsDataTable, dataSet] = pcnsDataExtract(directories)

disp ("-------------1) Import para-fMRI data ---------------")

%% LOAD psychosis datafile
%file = directories.parafMRIdata; 
data = readtable(fullfile(directories.parafMRIdata, "CogEmotPsych_DATA_2025-10-13_1359.csv")); 

dataSet = getDataSetInfo(directories);

%Initialise variable arrays
record_id   = NaN(dataSet.nParticipants,1);
group       = NaN(dataSet.nParticipants,1);
sex         = NaN(dataSet.nParticipants,1);
age_years   = NaN(dataSet.nParticipants,1);
FSIQ        = NaN(dataSet.nParticipants,1);
edu_cat     = NaN(dataSet.nParticipants,1);
meds_chlor  = NaN(dataSet.nParticipants,1);
valid_cfacei  = NaN(dataSet.nParticipants,1);
panss         = NaN(dataSet.nParticipants,1);
panssPositive = NaN(dataSet.nParticipants,1);
panssNegative = NaN(dataSet.nParticipants,1);
% baselineHR = NaN(IDspan,1);
% incongruentHRaverage = NaN(IDspan,1);
% congruentHRaverage = NaN(IDspan,1);

%% EXTRACT data

% loop through REDCap IDs
% get data
% write table


%% NEED TO ADD:
rowIdx = 1;

% loop through every possible record_id
for n = 1:dataSet.nParticipants
    id_rows   = find(data.record_id==dataSet.IDs(n)); % find data row(s) for single participant
    % if there are no data rows
    if ~isempty(id_rows)
        % identify which rows correspond to which variable
        details_row  = intersect(id_rows,find(strcmp(data.redcap_repeat_instrument,'participant_details')));
        demogr_row   = intersect(id_rows,find(strcmp(data.redcap_repeat_instrument,'demographics')));
        clinical_row = intersect(id_rows,find(strcmp(data.redcap_repeat_instrument,'clinical')));
        % if there are duplicates, keep only the first
        if numel(details_row)>1
            details_row = details_row(1);
        end
        if numel(demogr_row)>1
            demogr_row = demogr_row(1);
        end
        if numel(clinical_row)>1
            clinical_row = clinical_row(1);
        end

        %% omit exclusions: not pilot
        % note that this doesn't entirely work as this loop inlcudes the participant details row,
        % which does not have pilot info, hence adding those pilot ids
        % and age to the final table

        %% add more exclusions (see end of file)?
        
        % apply exclusion criteria
        if data.valid_any(demogr_row) ~= 1 %data not valid
            continue;
        end
       
        if data.fsiq2(demogr_row) < 80 % IQ <80
            continue;
        end
        if data.pilotorreal(demogr_row) ~=2 % pilot subject rather than "real" one
            continue;
        end
        if rowIdx == 1
            record_id(rowIdx,:) = data.record_id(details_row);
            age_years(rowIdx,:) = data.age_years(details_row);
            group(rowIdx,:)    = data.group(demogr_row);
            sex(rowIdx,:)      = data.sex(demogr_row);
            edu_cat(rowIdx,:)  = data.edu_cat(demogr_row);
            FSIQ(rowIdx,:)  = data.fsiq2(demogr_row);
            meds_chlor(rowIdx,:)  = data.meds_chlor(demogr_row);
            valid_cfacei(rowIdx,:)  = data.valid_cfacei(demogr_row);
            %HR = cFaceHR(record_id(rowIdx));
            % baselineHR(rowIdx,:) = HR.baseline;
            % incongruentHRaverage(rowIdx,:) = HR.incongruentAverage;
            % congruentHRaverage(rowIdx,:) = HR.congruentAverage;

            %% GET and ORGANIZE PANSS data from REDCap export
            if ~isempty(clinical_row)
                sum_panssPositive = 0;
                sum_panssNegative = 0;
                sum_panssGeneral = 0;
                for i = 1:7
                    varname = ['panss_p', num2str(i)];
                    sum_panssPositive = sum_panssPositive + data.(varname)(clinical_row);
                end
                for i = 1:7
                    varname = ['panss_n', num2str(i)];
                    sum_panssNegative = sum_panssNegative + data.(varname)(clinical_row);
                end
                for i = 1:16
                    varname = ['panss_g', num2str(i)];
                    sum_panssGeneral = sum_panssGeneral + data.(varname)(clinical_row);
                end
                panss(rowIdx,:) = sum_panssPositive + sum_panssNegative + sum_panssGeneral;
                panssPositive(rowIdx,:) = sum_panssPositive;
                panssNegative(rowIdx,:) = sum_panssNegative;

            end
            
            % update index for the first time
            rowIdx = rowIdx+1;
        else
            record_id(rowIdx,:) = data.record_id(details_row);
            age_years(rowIdx,:) = data.age_years(details_row);
            group(rowIdx,:)    = data.group(demogr_row);
            sex(rowIdx,:)      = data.sex(demogr_row);
            edu_cat(rowIdx,:)  = data.edu_cat(demogr_row);
            FSIQ(rowIdx,:)  = data.fsiq2(demogr_row);
            meds_chlor(rowIdx,:)  = data.meds_chlor(demogr_row);
            valid_cfacei(rowIdx,:)  = data.valid_cfacei(demogr_row);
            % HR = cFaceHR(record_id(rowIdx));
            % baselineHR(rowIdx,:) = HR.baseline;
            % incongruentHRaverage(rowIdx,:) = HR.incongruentAverage;
            % congruentHRaverage(rowIdx,:) = HR.congruentAverage;
            %% GET and ORGANIZE PANSS data from REDCap export
            if ~isempty(clinical_row)
                sum_panssPositive = 0;
                sum_panssNegative = 0;
                sum_panssGeneral = 0;
                for i = 1:7
                    varname = ['panss_p', num2str(i)];
                    sum_panssPositive = sum_panssPositive + data.(varname)(clinical_row);
                end
                for i = 1:7
                    varname = ['panss_n', num2str(i)];
                    sum_panssNegative = sum_panssNegative + data.(varname)(clinical_row);
                end
                for i = 1:16
                    varname = ['panss_g', num2str(i)];
                    sum_panssGeneral = sum_panssGeneral + data.(varname)(clinical_row);
                end
                panss(rowIdx,:) = sum_panssPositive + sum_panssNegative + sum_panssGeneral;
                panssPositive(rowIdx,:) = sum_panssPositive;
                panssNegative(rowIdx,:) = sum_panssNegative;
            end
            rowIdx = rowIdx+1;
        end
    end
end

pcnsDataTable = table(record_id, group, age_years, sex, edu_cat, FSIQ, meds_chlor, panss, panssPositive, panssNegative, 'VariableNames',...
    {'ID','group', 'age','sex','education', 'FSIQ','Chlorpromazine equivalents (mg)','panss','panssPositive','panssNegative'});

deleteIds = find(isnan(pcnsDataTable.ID));
pcnsDataTable(deleteIds,:) = [];

writetable(pcnsDataTable, fullfile(directories.parafMRIdata, 'pcnsDataTable.csv'))
disp ("Para-fMRI data saved as pcnsDataTable at " + directories.parafMRIdata)
end
