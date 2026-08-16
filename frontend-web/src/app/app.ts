import { Component, OnInit, inject } from '@angular/core';
import { HttpClient, HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [HttpClientModule],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App implements OnInit {
  private http = inject(HttpClient);
  public mensaje: string = 'Cargando estado del backend...';

  ngOnInit(): void {
    this.http.get<any>('http://localhost:8000/health').subscribe({
      next: (res) => {
        this.mensaje = `${res.message} (v${res.version})`;
      },
      error: () => {
        this.mensaje = 'Error al conectar con el servidor Backend.';
      }
    });
  }
}