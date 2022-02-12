/**
 * Small set of scripts for adjusting the search
 * 
 * 
 */
 
const Sch = new StaticSearch();
Sch.searchFinishedHook = function(n){
    Sch.resultsDiv.querySelectorAll('a.fidLink').forEach(link => {
        let hash = link.href.split('#').at(-1);
        let text = '→';
        if (/^l\d+\.\d+$/gi.test(hash)){
            text += ` Go to ${hash}`;
        }
        link.innerHTML = text;
    });
}    
  
 
 

 