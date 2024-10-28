/********************************************************
*                                                       *
* Javascript for the footer plugin for Reveal.js  *
*                                                       *
* Author: Igor Leturia                                  *
*                                                       *
* License: GPL v3                                       *
* http://www.gnu.org/copyleft/gpl.html                  *
*                                                       *
********************************************************/

/* footer object and properties declaration with default values */

var footer_js=
{
	title: ' ',
	background:'none',
};

/* Function to obtain all child elements with any of the indicated tags (from http://www.quirksmode.org/dom/getElementsByTagNames.html) */

footer_js.getElementsByTagNames=function(list,obj)
{
	if (!obj)
	{
		var obj=document;
	};
	var tagNames=list.split(',');
	var resultArray=new Array();
	for (var i=0;i<tagNames.length;i++)
	{
		var tags=obj.getElementsByTagName(tagNames[i]);
		for (var j=0;j<tags.length;j++)
		{
			resultArray.push(tags[j]);
		};
	};
	var testNode=resultArray[0];
	if (!testNode)
	{
		return [];
	};
	if (testNode.sourceIndex)
	{
		resultArray.sort(
			function (a,b)
			{
				return a.sourceIndex-b.sourceIndex;
			}
		);
	}
	else if (testNode.compareDocumentPosition)
	{
		resultArray.sort(
			function (a,b)
			{
				return 3-(a.compareDocumentPosition(b)&6);
			}
		);
	};
	return resultArray;
};

/* Method to initialize the footer footer */

footer_js.initialize=function(title,background)
{

	// Link to the footer CSS

	var link=document.createElement("link");
	link.href="plugin/footer/footer.css";
	link.type="text/css";
	link.rel="stylesheet";
	document.getElementsByTagName("head")[0].appendChild(link);

	// Initialize properties according to parameters

	this.background=background;
	var title=title || ' ';
	if (title!='')
	{
		this.title=title;
	}
	else
	{
		var first_section=document.getElementsByTagName('section')[0];
		if (first_section.getElementsByTagName('section').length>0)
		{
			first_section=first_section.getElementsByTagName('section')[0];
		};
		var title_elements=this.getElementsByTagNames('h1,h2,h3',first_section);
		if (title_elements.length>0)
		{
			this.title=title_elements[0].textContent;
			for (var title_elements_index=1;title_elements_index<title_elements.length;title_elements_index++)
			{
				this.title=this.title+' - '+title_elements[title_elements_index].textContent;
			};
		};
	};

	// Create the footer footer

	var footer_js=document.createElement('footer');
	footer_js.setAttribute('id','footer');
	footer_js.setAttribute('style','background:'+this.background);

	// Create a container for the title and logo
	var footer_js_container = document.createElement('div');
	footer_js_container.setAttribute('style', 'display: flex; align-items: center; justify-content: space-between; width: 100%;');

	// Add the logo
	var logo=document.createElement('img');
	logo.setAttribute('src', 'assets/logos/LiU_primary_white.png');
	logo.setAttribute('alt', 'Logo');
	logo.setAttribute('style', 'height: 10vh;');  // Adjust the height as needed
	footer_js_container.appendChild(logo);

	// Add the title
	var footer_js_p=document.createElement('p');
	var a_element=document.createElement('a');
	a_element.setAttribute('href','#/0');
	a_element.appendChild(document.createTextNode(this.title));
	footer_js_p.appendChild(a_element);
	footer_js_p.setAttribute('style', 'margin-left: auto;');  // Ensure title is on the right
	footer_js_container.appendChild(footer_js_p);

	// Append the container to the footer
	footer_js.appendChild(footer_js_container);

	var div_class_reveal=document.querySelectorAll('.reveal')[0];
	div_class_reveal.appendChild(footer_js);
};
