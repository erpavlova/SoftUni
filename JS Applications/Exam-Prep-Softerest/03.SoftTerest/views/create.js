import { html } from "../node_modules/lit-html/lit-html.js";

import { createIdea } from '../src/api/data.js';

const createIdeaTemplate = (onSubmit) => html`
<div id="create-page" class="container home wrapper  my-md-5 pl-md-5">
    <div class=" d-md-flex flex-mb-equal ">
        <div class="col-md-6">
            <img class="responsive-ideas create" src="./images/creativity_painted_face.jpg" alt="">
        </div>
        <form @submit=${onSubmit} class="form-idea col-md-5" action="#/create" method="post">
            <div class="text-center mb-4">
                <h1 class="h3 mb-3 font-weight-normal">Share Your Idea</h1>
            </div>
            <div class="form-label-group">
                <label for="ideaTitle">Title</label>
                <input type="text" id="title" name="title" class="form-control" placeholder="What is your idea?"
                    required="" autofocus="">
            </div>
            <div class="form-label-group">
                <label for="ideaDescription">Description</label>
                <textarea type="text" name="description" class="form-control" placeholder="Description"
                    required=""></textarea>
            </div>
            <div class="form-label-group">
                <label for="inputURL">Add Image</label>
                <input type="text" id="imageURl" name="imageURL" class="form-control" placeholder="Image URL"
                    required="">

            </div>
            <button class="btn btn-lg btn-dark btn-block" type="submit">Create</button>

            <p class="mt-5 mb-3 text-muted text-center">© SoftTerest - 2021.</p>
        </form>
    </div>
</div>`;


export async function ideaCreate(ctx) {
    //console.log('create page');

    ctx.render(createIdeaTemplate(onSubmit));

    async function onSubmit(event) {
        event.preventDefault();
        const formData = new FormData(event.target);

        let title = formData.get('title');
        let description = formData.get('description');
        let ideaImg = formData.get('imageURL');


        if (!title || !description || !ideaImg) {
            return alert('All fields are required!');
        }
        if (title.length < 6) {
            return alert('Idea title must be at least 6 characters long!');
        }
        
        if (description.length < 10) {
            return alert('Idea description must be at least 10 characters long!');
        }
        
        if (ideaImg.length < 5) {
            return alert('Image URL must be at least 5 characters long!');
        }

        await createIdea({ title, description, ideaImg });

        ctx.page.redirect('/catalog');

        // event.target.reset();

    }
};