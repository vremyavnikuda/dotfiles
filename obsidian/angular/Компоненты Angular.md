#angular #frontend #ts #компоненты

```ts
@Component({  
  selector: 'app-first',  
  standalone: true,  
  imports: [CommonModule, RouterOutlet],  
  templateUrl: './first.component.html',  
  styleUrl: './first.component.css'  
})  
export class FirstComponent {  
  
}
```

>тестирование компонента


```ts
describe('FirstComponent', () => {  
  let component: FirstComponent;  
  let fixture: ComponentFixture<FirstComponent>;  
  
  beforeEach(async () => {  
    await TestBed.configureTestingModule({  
      imports: [FirstComponent]  
    })  
    .compileComponents();  
      
    fixture = TestBed.createComponent(FirstComponent);  
    component = fixture.componentInstance;  
    fixture.detectChanges();  
  });  
  
  it('should create', () => {  
    expect(component).toBeTruthy();  
  });  
});
```