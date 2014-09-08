$(document).ready(function() {

	//get species data from database
	$.post('/speciesnames', function(species){
		$( "#species-input" ).autocomplete({
			source: species,
    	minLength: 3,
  	});
	});

	$.post('/speciesnames', function(species){
		$( "#species-input-instructions" ).autocomplete({
			source: species,
    	minLength: 3,
  	});
	});

	//search for species in database
	// $('#species-search').on('submit', function(event){
	// 	event.preventDefault();
	// 	var species = $('input').val();
	// 	$.post('/species', {species: species}, function(foundSpecies){
	// 		console.log(foundSpecies)
	// 	});
	// });

});//end doc ready
