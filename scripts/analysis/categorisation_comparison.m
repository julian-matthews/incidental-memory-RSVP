
function categorisation_comparison

files = {'01_VC' '99_JM'};

save_location = '../../data/image_categorisation/';

% Save the comparison matrix?
SAVEIT = 1;

% Update the all_faces struct?
UPDATE_ALL = 1;

% Load image categorisation data & save as level in "Set" struct
for loading = 1:length(files)
    
    load([save_location files{loading} '_faces.mat']);
    
    Set(loading) = Cats;
    
end

number_of_participants = length(Set);

number_of_faces = length(Set(1).test_faces);

% Nessi face_num, Julian face_num, Nessi selek, Julian selek, same?
comparison = NaN(number_of_faces,(number_of_participants*2+1));

% For all of participant #1's categorisations
for categorisation = 1:number_of_faces
    
    face_to_find = Set(1).test_faces(categorisation).face;
    
    comparison(categorisation,1) = face_to_find;
    
    % Nessi's categorisation
    comparison(categorisation,(number_of_participants+1)) = Set(1).test_faces(categorisation).category_selek.gender;
    
    for participant = 1:number_of_participants
        
        for face_number = 1:number_of_faces
            
            if Set(participant).test_faces(face_number).face == face_to_find
                
                found_face = face_number;
                
                % Check if same image
                comparison(categorisation,(1+participant)) = Set(participant).test_faces(found_face).face;
                
                % Julian's categorisation
                comparison(categorisation,(number_of_participant+(1+participant))) = Set(participant).test_faces(found_face).category_selek.gender;
                
                
            end
            
        end
        
    end
    
end

% Comparisons between subjects
for row = 1:number_of_faces
    
    if comparison(row,3) == 1 && comparison(row,4) == 1
        comparison(row,5) = 1;
        
    elseif comparison(row,3) == 0 && comparison(row,4) == 0
        comparison(row,5) = 0;
        
    elseif comparison(row,3) == 2 && comparison(row,4) == 2
        comparison(row,5) = 2;
        
    elseif comparison(row,3) == 0 && comparison(row,4) == 2
        
        % Code '88' if only Julian uncertain
        comparison(row,5) = 88;
        
    elseif comparison(row,3) == 1 && comparison(row,4) == 2
        comparison(row,5) = 88;
        
    elseif comparison(row,3) == 2 && comparison(row,4) == 0
        
        % Code '77' if only Vanessa uncertain
        comparison(row,5) = 77;
        
    elseif comparison(row,3) == 2 && comparison(row,4) == 1
        comparison(row,5) = 77;
        
    elseif comparison(row,3) == 1 && comparison(row,4) == 0
        
        % Code '66' if selections disagree
        comparison(row,5) = 66;
        
    elseif comparison(row,3) == 0 && comparison(row,4) == 1
        comparison(row,5) = 66;
        
    else
        
        comparison(row,5) = 99;
        
    end
    
end

if SAVEIT
    
    save('../../data/image_categorisation/latest_comparison', 'comparison');
    
end

if UPDATE_ALL
    % all_faces_updated.mat in save_location
    load([save_location 'all_faces_updated.mat']);

    temp = all_faces;
    
    for selection = 1:number_of_faces
    
        % Find spots where Vanessa & I have agreed
        % Input the agreed 'comparison(face_num,5)' value into all_face_updated
        
        if comparison(selection,5) == 0
            
            temp(selection).category_selek.gender = 0; % Selection "female"
            temp(selection).category_flags.gender = 1; % Flagged complete
            
        elseif comparison(selection,5) == 1
    
            temp(selection).category_selek.gender = 1; % Selection "male"
            temp(selection).category_flags.gender = 1; % Flagged complete
            
        elseif comparison(selection,5) == 2
            
            temp(selection).category_selek.gender = 2; % Selection "uncertain"
            temp(selection).category_flags.gender = 1; % Flagged complete
            
        end
    end
end

end