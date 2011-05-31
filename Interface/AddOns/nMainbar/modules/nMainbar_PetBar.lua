
PetActionBarFrame:SetFrameStrata('HIGH')

PetActionBarFrame:SetScale(nMainbar.petBar.scale)
PetActionBarFrame:SetAlpha(nMainbar.petBar.alpha)
   
   -- horizontal/vertical bars
 
if (nMainbar.petBar.vertical) then
	for i = 2, 10 do
		button = _G['PetActionButton'..i]
		button:ClearAllPoints()
		button:SetPoint('TOP', _G['PetActionButton'..(i - 1)], 'BOTTOM', 0, -8)
	end
end